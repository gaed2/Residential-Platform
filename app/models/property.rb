class Property < ApplicationRecord

  ATTACHMENTS = %w[electrical_distribution_schematic_diagram equipment_list_and_specification pdf_report]

  ATTACHMENTS.each do |upload_type|
    mount_uploader upload_type, "Property::#{upload_type.classify}Uploader".constantize
  end

  enum status: { update_awaiting: 0, updated_to_block: 1 }

  belongs_to :user
  belongs_to :property_sub_category
  belongs_to :current_electricity_supplier, class_name: 'ElectricitySupplier',
              foreign_key: 'current_electricity_supplier_id', inverse_of: :properties, optional: true
  has_many :energy_data, dependent: :destroy
  has_many :electricity_consumption_equipments, dependent: :destroy
  has_many :property_checklists, dependent: :destroy
  has_many :equipment_maintenances, dependent: :destroy
  has_many :past_year_utility_bills, dependent: :destroy
  has_many :renewable_energy_sources, dependent: :destroy
  has_many :blockchain_datum
  belongs_to :city, optional: true
  belongs_to :suppliers_plan, optional: true

  scope :by_owner_name, -> (owner_name) { where("LOWER(owner_name) ILIKE ?", "%#{owner_name}%") }
  scope :by_owner_email, -> (owner_email) { where("LOWER(owner_email) ILIKE ?", "%#{owner_email}%") }
  scope :by_locality, -> (locality) { where("LOWER(locality) ILIKE ?", "%#{locality}%") }
  scope :by_state, -> (state) { where("LOWER(state) ILIKE ?", "%#{state}%") }
  scope :by_city, -> (city) { where("LOWER(city) ILIKE ?", "%#{city}%") }
  scope :by_country, -> (country) { where("LOWER(country) ILIKE ?", "%#{country}%") }
  scope :list, ->  { where(draft: false) }
  scope :drafts_only, ->  { where(draft: true) }

  # Check if current supplier is SP group(default for singapore)
  def is_supplier_sp_group?
    current_electricity_supplier&.name == 'SP Group'
  end

  # Complete address
  def full_address
    property_address = ""
    if is_landed?
      property_address << "#{door_name_label} #{door_name}, " if door_name
      property_address << "floor number #{floor_number}, " if floor_number
      property_address << "#{locality&.capitalize}, "
      property_address << country 
    else
      property_address << "#{locality&.capitalize}, "
      property_address << "floor number #{floor_number}, " if floor_number
      property_address << "#{door_name_label} #{door_name}, " if door_name
      property_address << country
    end
    property_address
  end

  def door_name_label
    return 'house number' if is_landed?
    'unit number'
  end

  def city_name
    city&.name
  end

  def state
   city&.region&.name
  end

  def at_home_time
    "#{start_time.strftime(Constant::HOME_TIME_FORMAT)} to #{end_time.strftime(Constant::HOME_TIME_FORMAT)}" if start_time && end_time
  end

  # User duration of stay at property
  def duration_of_stay
    year = 'year'.pluralize(duration_of_stay_year)
    month = 'month'.pluralize(duration_of_stay_month)
    stay_duration = ""
    stay_duration += "#{duration_of_stay_year} #{year}" if duration_of_stay_year
    stay_duration += " & " if duration_of_stay_year && duration_of_stay_month
    stay_duration += "#{duration_of_stay_month} #{month}" if duration_of_stay_month
    stay_duration
  end

  def daily_dryer_usage_time
    hour = 'hour'.pluralize(daily_dryer_usage)
    daily_dryer_usage.to_s + " " + hour
  end

  def ac_usage_time
    "#{ac_start_time.strftime(Constant::HOME_TIME_FORMAT)} to #{ac_stop_time.strftime(Constant::HOME_TIME_FORMAT)}" if ac_start_time && ac_stop_time
  end

  def current_supplier_duration
    "#{different_supplier_to.strftime(Constant::MONTH_YEAR_FORMAT)} - #{different_supplier_to.strftime(Constant::MONTH_YEAR_FORMAT)}" if different_supplier_from && different_supplier_to
  end

  def hash_energy_data?
    energy_data.count > 0
  end

  def avg_monthly_electricity_consumption
    return 0 unless hash_energy_data?
    energy_data.average(:energy_consumption).round(2)
  end

  def avg_monthly_electricity_bill
    return 0 unless hash_energy_data?
    energy_data.average(:cost).round(2)
  end

  def category_name
    property_sub_category&.property_category&.name
  end

  # Property type
  def name
    property_sub_category&.name&.downcase
  end

  # Building image name
  def building_image
    return 'room.png' if name.match('room').present? || name.match('maisonette').present?
    return 'condo.jpg' if name.match('condo').present?
    'terrace.jpg'
  end

  # If property is landed
  def is_landed?
    name.match('terrace').present? || name.match('bungalow').present? || name.match('detached').present?
  end

  # Display solar solution
  def display_solar_solution?
    name.match('terrace').present? || name.match('bungalow').present? || name.match('detached').present?
  end

  def one_room?
    name == '1-room'
  end

  def two_or_more_rooms?
    name.match('room').present? && !one_room?
  end

  def executive?
    name == 'executive'
  end

  def maisonette?
    name == 'maisonette'
  end

  def condo?
    name == 'condo'
  end

  def terrace?
    name == 'terrace'
  end

  def bungalow?
    name == 'bungalow'
  end

  def total_rooms
    name&.split('-').first.to_i
  end

  def other_consumptions_in_kwh
    "#{other_consumptions} #{I18n.t('energy_unit')}"
  end

  def address
    return "#{locality&.capitalize}, #{zip}, #{country}" if locality && zip
    return "#{locality&.capitalize}, #{country}" if locality
    country
  end

  def estimated_monthly_bill(price, plan_type)
    "BillCalculator::#{category_name}".constantize.estimated_monthly_bill(self, price, plan_type)
  end

  def estimated_peak_monthly_bill(peak_price, peak_price_type)
    "BillCalculator::#{category_name}".constantize.estimated_peak_monthly_bill(self, peak_price, peak_price_type)
  end

  def estimated_peak_off_monthly_bill(peak_off_price, peak_off_price_type)
    "BillCalculator::#{category_name}".constantize.estimated_peak_off_monthly_bill(self, peak_off_price, peak_off_price_type)
  end

  def checklist_answer
    checklist_hash = {}
    property_checklists.each do |property_checklist|
      checklist_hash.merge!("#{property_checklist.energy_saving_checklist_id}" => property_checklist.answer)
    end
    checklist_hash
  end

  def checklist_ids
    checklist_hash = {}
    property_checklists.each do |property_checklist|
      checklist_hash.merge!("#{property_checklist.energy_saving_checklist_id}" => property_checklist.id)
    end
    checklist_hash
  end

  def house_area
    "#{total_house_size} #{total_house_unit}"
  end

  def total_house_size_in_sqm
    return unless total_house_size
    (0.092903 * total_house_size)&.round(2)
  end

  def total_no_of_people
    total_member = adults.to_i + children.to_i + senior_citizens.to_i
    return 'X' if total_member == 0
    total_member
  end

  def max_energy_consumption
    "#{energy_data.maximum(:energy_consumption)&.round(2)} #{I18n.t('energy_unit')}"
  end

  def total_energy_consumption_cost
    energy_data.sum(:cost)&.round(2)
  end

  def min_energy_consumption
    "#{energy_data.minimum(:energy_consumption)&.round(2)} #{I18n.t('energy_unit')}"
  end

  def min_energy_consumption_month
    energy_data.group(:month).minimum(:energy_consumption).sort_by{ |k, v| v.to_f }.to_h.keys.first
  end

  def max_energy_consumption_month
    energy_data.group(:month).maximum(:energy_consumption).sort_by{ |k, v| v.to_f }.to_h.keys.last
  end

  def count_energy_data
    energy_data.count(:energy_consumption)
  end

  def total_energy_consumption
    "#{energy_data.sum(:energy_consumption)&.round(2)} #{I18n.t('energy_unit')}"
  end

  def has_appliances?
    electricity_consumption_equipments.count > 0
  end

  def has_ac?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:ac])
  end

  def has_dryer?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:dryer])
  end

  def has_aircon?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:aircon])
  end

  def has_tv?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:tv], equipment_type: 'Plasma')
  end

  def has_fluorescent?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:ls], equipment_type: 'Fluorescent')
  end

  def has_refrigerator?
    electricity_consumption_equipments.find_by("name = ? AND  rating < 3 ", Constant::EQUIPMENTS_HASH[:fridge]).present?
  end

  def has_low_rating?
    electricity_consumption_equipments.find_by("name in('Air conditioning system', 'Hot Water system', 'Washing Machine & Dryer') AND  rating < 3 ").present?
  end

  def has_smart_home_system?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:shs])
  end

  # Has top loading washing machine
  def has_top_loading_washing_machine?
    electricity_consumption_equipments.exists?(name: Constant::EQUIPMENTS_HASH[:wm], equipment_type: 'Top loading')
  end

  # Lightning systems
  def lightning_systems
    electricity_consumption_equipments.where(name: Constant::EQUIPMENTS_HASH[:ls])
  end

  # Hot water systems
  def hot_water_systems
    electricity_consumption_equipments.where(name: Constant::EQUIPMENTS_HASH[:hw])
  end

  # Smart home systems
  def smart_home_systems
    electricity_consumption_equipments.where(name: Constant::EQUIPMENTS_HASH[:shs])
  end

  # Cooling systems
  def cooling_systems
    electricity_consumption_equipments.where(name: Constant::EQUIPMENTS_HASH[:ac])
  end

  # Other systems
  def other_systems
    electricity_consumption_equipments.where.not(name: [Constant::EQUIPMENTS_HASH[:ac], Constant::EQUIPMENTS_HASH[:hw],
                                                        Constant::EQUIPMENTS_HASH[:shs], Constant::EQUIPMENTS_HASH[:ls]]
                                                )
  end

  # Fetch not upgraded appliances
  def fetch_not_upgraded(type)
    electricity_consumption_equipments.where('name =? AND year_installed <?',
                                              Constant::EQUIPMENTS_HASH[type.to_sym], Constant::EQUIPMENT_VALIDITY_YEAR).last
  end

  def current_regulated_rate
    return supplier_electricity_rate if supplier_electricity_rate.present? && supplier_electricity_rate > 0
    return 0 unless hash_energy_data?
    (avg_monthly_electricity_bill.to_f*100/avg_monthly_electricity_consumption.to_f).round(2)
  end

  def top_three_retailers
    SuppliersPlan.find_by_sql("select *,  (CASE
                                             WHEN suppliers_plans.price_type = 0
                                               THEN (#{avg_monthly_electricity_bill} - (#{avg_monthly_electricity_consumption*current_regulated_rate/100} * suppliers_plans.price/100))
                                             ELSE (suppliers_plans.price/100*#{avg_monthly_electricity_consumption}/100)
                                           END) as estimated_cost from suppliers_plans
                                ORDER BY estimated_cost
                                LIMIT #{Constant::DEFAULT_PLAN_LIMIT}")
  end

  def energy_save_recommendation
    data = {}
    property_checklists.each do |checklist|
      data.merge!("#{checklist.energy_saving_checklist.heading}" => checklist.answer)
    end
    data
  end

  def save_documents_data
    ATTACHMENTS.each do |p_attachment|
      file_path = send("#{p_attachment}_url".to_sym)
      next unless file_path
      DataEncryptor::DataSaver.save_data(self, file_path, nil, false, 'provided_document')
    end
  end

  def save_bill_data
    past_year_utility_bills.each do |p_y_bill|
      next(p_y_bill) unless p_y_bill.file_url

      DataEncryptor::DataSaver.save_data(self, p_y_bill.file_url, nil, false, 'provided_document')
    end
  end

  # Solar PV
  def solar_pv
    SolarPvSystem.last
  end

  # Compare plan
  def compare_plan(plan_id)
    SuppliersPlan.find_by_sql("select *,  (CASE
                                 WHEN suppliers_plans.price_type = 0
                                   THEN (#{avg_monthly_electricity_bill} - (#{avg_monthly_electricity_consumption*current_regulated_rate/100} * suppliers_plans.price/100))
                                 ELSE (suppliers_plans.price/100*#{avg_monthly_electricity_consumption}/100)
                                       END) as estimated_cost from suppliers_plans WHERE suppliers_plans.id= #{plan_id}
                              ORDER BY estimated_cost
                              LIMIT 1")
  end
end
