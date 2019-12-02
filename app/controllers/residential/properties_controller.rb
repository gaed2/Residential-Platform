class Residential::PropertiesController < BaseController
  before_action :fetch_property_categories_and_energy_saving_checklists, only: %w[new edit]
  before_action :set_property, only: %w[show edit update destroy update_energy_data update_energy_checklist remove_data draft update_draft]
  before_action :check_draft_property, only: %w[show edit update update_energy_data update_energy_checklist]
  before_action :check_property_owner, only: %w[show edit update destroy update_energy_data update_energy_checklist remove_data]
  layout 'audit', except: %w[show]

  def index
    @properties = current_user.properties.includes(property_sub_category: :property_category)
  end

  def show
    @default_partial = params[:partial] || 'general_details'
    @energy_saving_checklists = EnergySavingChecklist.all
    render partial: "residential/properties/show" if request.xhr?
  end

  def new
    @categories = PropertyCategory.all
    @energy_saving_checklists = EnergySavingChecklist.all
  end

  def edit
    return render_error_response('not_found') unless Constant::EDIT_ENERGY_DATA_PARTIALS.include?(params[:partial])
    render partial: "residential/properties/edit/#{params[:partial]}"
  end

  def destroy
    flash[:notice] = @property.destroy ? t('property.deleted_successfully') : @property.errors.full_messages.to_sentence
    return redirect_to draft_path
  end

  # Draft property
  def draft
    @categories = PropertyCategory.all
    @energy_saving_checklists = EnergySavingChecklist.all
  end

  # Update draft
  def update_draft
    # TODO: need to refactor this
    update
    update_energy_checklist
    update_energy_data
    return render_success_response('', id: @property.id) if params[:property][:current_step].to_i != 3 && params[:action_type] == 'save_and_next'
    if params[:action_type] == 'save_as_draft' && !params[:draft_confirm]
      flash[:notice] = t('property.draft_saved')
      return render js: "window.location = '/draft'"
    else
      # Generate PDF
      send_pdf
    end
  end

  def create
    outcome = Residential::Property::CreateIntr.run(property_data.reject { |_, v| v.blank? }.merge(user: current_user))
    return render_error_response(outcome.errors.full_messages.to_sentence) unless outcome.valid?
    if outcome.result.draft
      return render_success_response('', id: outcome.result.id) if params[:action_type] == 'save_and_next'
      flash[:notice] = t('property.draft_saved')
      return render js: "window.location = '/draft'"
    end
    @property = Property.find_by(id: outcome.result.id)
    # Generate PDF
    send_pdf
  end

  def update
    outcome = Residential::Property::UpdateIntr.run(property_data.reject{|_, v| v.blank?}.merge(property: @property))
    return render_error_response(outcome.errors.full_messages.to_sentence) unless outcome.valid?
    # TODO
    #@property.update_attributes(property_data.reject{|_, v| v.present?})
    if params[:renewable_energy_sources].present?
      renewal_energy_sources = Residential::RenewableEnergySource::UpdateIntr.run(property: @property,
                                                                                  renewable_energy_sources: parse_json(params[:renewable_energy_sources]))
      return render_error_response(renewal_energy_sources.errors.full_messages.to_sentence) unless renewal_energy_sources.valid?
    end
    unless params[:action_type]
      enqueue_data_create_worker('fetch_general_details')
      render_property_details('general_details')
    end
  end

  def update_energy_data
    resetEnergyData if params[:action_type] == 'save_and_next' && params[:property][:current_step].to_i == 2
    if params[:energy_data].present?
      outcome = Residential::EnergyData::UpdateIntr.run(property: @property,
                                                        energy_data: parse_json(params[:energy_data])
                                                       )
      return render_error_response(outcome.errors.full_messages.to_sentence) unless outcome.valid?
    end
    # Update equipment
    if params[:other_installed_equipments].present?
      equipment_outcome = Residential::ElectricityConsumptionEquipment::UpdateIntr.run(property: @property,
                                                                                       equipments: parse_json(params[:other_installed_equipments])
                                                                                       )
      return render_error_response(equipment_outcome.errors.full_messages.to_sentence) unless equipment_outcome.valid?
    end
    @property.update_attributes(electricity_supplier_params) if electricity_supplier_params
    update_utility_bills if params[:utility_bills].present?
    unless params[:action_type]
      enqueue_data_create_worker("fetch_energy_data_details")
      render_property_details('energy_data')
    end
  end

  # Update property bills
  def update_utility_bills
    outcome = Residential::UtilityBills::UpdateIntr.run(property: @property,
                                                        utility_bills: utility_bill_params)
    return render_error_response(outcome.errors.full_messages.to_sentence) unless outcome.valid?
  end

  def update_energy_checklist
    # Update energy checklist
    if params[:energy_saving_checklist].present?
      checklist_outcome = Residential::Checklist::UpdateIntr.run(property: @property, property_checklist: parse_json(params[:energy_saving_checklist]))
      return render_error_response(checklist_outcome.errors.full_messages.to_sentence) unless checklist_outcome.valid?
    end
    # Update equipment
    if params[:equipment_maintenances].present?
      maintenance_outcome = Residential::EquipmentMaintenance::UpdateIntr.run(property: @property, equipment_maintenances: parse_json(params[:equipment_maintenances]))
      return render_error_response(maintenance_outcome.errors.full_messages.to_sentence) unless maintenance_outcome.valid?
    end
    unless params[:action_type]
      enqueue_data_create_worker("fetch_checklist_details")
      render_property_details('energy_save_checklist')
    end
  end

  # Remove property data
  def remove_data
    outcome = Residential::Property::DeleteIntr.run(property: @property, entity: params[:model], entity_id: params[:entity_id])
    return render_success_response(t('deleted_successfully')) if outcome.valid?
    render_error_response(outcome.errors.full_messages.to_sentence)
  end

  private

  def set_property
    @property ||= current_user.properties.includes(:energy_data, :electricity_consumption_equipments,
                                                    property_sub_category: :property_category).find(params[:id])
  end

  def check_draft_property
    return redirect_to root_path if @property&.draft
  end

  def render_property_details(partial)
    @default_partial = partial
    @property.reload
    render partial: 'residential/properties/show'
  end

  # Check if user property owner
  def check_property_owner
    return redirect_to root_path unless current_user.id == @property.user_id
  end

  def property_params
    params.require(:property).permit(:property_sub_category_id, :owner_name, :owner_email, :contact_number,
                                     :zip, :city_id, :country, :locality, :adults, :children, :current_electricity_supplier_id,
                                     :suppliers_plan_id, :senior_citizens, :bedrooms, :bathrooms, :floors, :avg_room_size,
                                     :living_room_size, :dining_room_size, :total_house_size, :floor_cieling_height,
                                     :start_time, :end_time, :electricity_consumption, :water_consumption,
                                     :different_supplier_from, :different_supplier_to, :natural_gas_consumption,
                                     :electrical_distribution_schematic_diagram, :equipment_list_and_specification,
                                     :electricity_consumption_unit, :natural_gas_unit, :water_unit,
                                     :avg_room_unit, :living_room_unit, :dining_room_unit, :total_house_unit, :floor_cieling_unit,
                                     :draft, :current_step, :roof_length, :roof_length_unit, :roof_breadth, :roof_breadth_unit,
                                     :avatar, :full_time_occupancy, :duration_of_stay_year, :duration_of_stay_month, :floor_number, :door_name,
                                     :has_ac, :has_solar_pv, :ac_units, :ac_temperature, :ac_start_time, :ac_stop_time, :supplier_electricity_rate,
                                     :ac_in_use, :people_at_home, :solar_power_consumption, :solar_power_consumption_unit, :has_dryer, :daily_dryer_usage

    )
  end

  # Electricity supplier params
  def electricity_supplier_params
    params.require(:property).permit(:current_electricity_supplier_id, :supplier_electricity_rate, :is_supplier_changed,
                                     :suppliers_plan_id, :different_supplier_from, :different_supplier_to)
  end

  # Parse json data
  def parse_json(data)
    JSON.parse(data)
  end

  def fetch_property_categories_and_energy_saving_checklists
    @property_categories = PropertyCategory.joins(:property_sub_categories)
    @energy_saving_checklists = EnergySavingChecklist.all
  end

  def property_data
    property_data_params = property_params
    property_data_params[:electricity_consumption_equipments] = parse_json(params[:other_installed_equipments]) if params[:other_installed_equipments].present?
    property_data_params[:property_checklist] = parse_json(params[:energy_saving_checklist]) if params[:energy_saving_checklist].present?
    property_data_params[:equipment_maintenances] = parse_json(params[:equipment_maintenances]) if params[:equipment_maintenances].present?
    property_data_params[:energy_data] = parse_json(params[:energy_data]) if params[:energy_data].present?
    property_data_params[:utility_bills] = utility_bill_params if params[:utility_bills].present?
    property_data_params[:renewable_energy_sources] = parse_json(params[:renewable_energy_sources]) if params[:renewable_energy_sources].present?
    property_data_params
  end

  # Send pdf to server
  def send_pdf
    load_report_data
    pdf = render_to_string pdf: 'some_file_name', layout: 'layouts/report.haml',
                           template: '/residential/reports/generate.haml',
                           footer: { center: '[page]' },
                           margin: { top: 10, left: 12, right: 12 },
                           encoding: 'UTF-8',
                           disable_javascript: false,
                           javascript_delay: 2000
    PropertyService.create_pdf(pdf, @property)
    begin
      Blockchain::DataCreateWorker.perform_async(@property.id)
    rescue Exception => e
      puts e.exception
    end
    return render js: "window.location = '#{property_path(@property)}'"
    #return render_success_response(t('property.added.success'), id: @property.id)
  end

  # Utility bill params
  def utility_bill_params
    utility_bills = []
    for index in 0..(params[:total_bills].to_i - 1 )
      data = 'category_'+index.to_s
      category = params[:utility_bills][data.to_s]
      utility_bills << {category: category.capitalize, file: params[:utility_bills]['bill_'+category+'_'+index.to_s] }
    end
    utility_bills
  end

  # Update blockchain ledgerboard data
  def enqueue_data_create_worker(current_tab)
    begin
      Blockchain::DataCreateWorker.perform_async(@property.id, current_tab)
    rescue Exception => e
      puts e.exception
    end
  end

  # Delete old energy data
  def resetEnergyData
    energy_data_ids = []; installed_system_ids = [];
    if params[:energy_data].present?
      energy_data_ids = parse_json(params[:energy_data]).collect{|ed| ed['id']}
    end
    if params[:other_installed_equipments].present?
      installed_system_ids = parse_json(params[:other_installed_equipments]).collect{|sys| sys['id']}
    end
    @property.energy_data.where.not(id: energy_data_ids).destroy_all
    # TODO
    #@property.past_year_utility_bills.destroy_all
    @property.electricity_consumption_equipments.where.not(id: installed_system_ids).destroy_all
  end

end
