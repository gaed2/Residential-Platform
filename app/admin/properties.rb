ActiveAdmin.register Property do
  actions :all, except: %w[edit destroy new]
  includes :user, :current_electricity_supplier, :property_sub_category
  remove_filter :user, :property_sub_category, :electricity_consumption_equipments, :energy_data, :property_checklists, :equipment_maintenances, :past_year_utility_bills,
                :from, :to, :electrical_distribution_schematic_diagram, :equipment_list_and_specification,
                :status, :created_at, :updated_at

  PROPERTY_SHOW_COLUMNS = %i[owner_name owner_email user property_sub_category contact_number zip locality
                             state city country adults children senior_citizens bedrooms floors avg_room_size
                             living_room_size dining_room_size total_house_size floor_cieling_height
                             electricity_consumption water_consumption
                             natural_gas_consumption other_consumptions current_electricity_supplier
                             from to electrical_distribution_schematic_diagram
                             equipment_list_and_specification].freeze

  %i[owner_name owner_email locality state city country].each do |col|
    collection_action "autocomplete_property_#{col}", method: :get do
      return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
      results = Property.select(col).instance_eval("by_#{col}('#{params[:term]}')")
      render json: results
    end
  end

  %i[owner_name owner_email locality country].each do |col|
    filter "#{col}_contains", input_html: {
            class: 'autocomplete-filter',
            data: {
              url: "/admin/properties/autocomplete_property_#{col}"
            }
    }, label: "#{col} contains", required: false
  end

  index do
    column :id
    (PROPERTY_SHOW_COLUMNS - %i[from to electrical_distribution_schematic_diagram equipment_list_and_specification]).each do |col|
      column col
    end
    column :most_occupant_will_be_at_home do |property|
      property.at_home_time
    end
    actions
  end

  show do
    attributes_table do
      PROPERTY_SHOW_COLUMNS.each do |row|
        row row
      end
      row :most_occupant_will_be_at_home do |property|
        property.at_home_time
      end
    end
  end
end
