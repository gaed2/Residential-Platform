# frozen_string_literal: true

class Residential::Property::CreateIntr < ApplicationInteraction
  array :energy_data, default: []
  array :electricity_consumption_equipments, default: []
  array :property_checklist, default: []
  array :equipment_maintenances, default: []
  array :renewable_energy_sources, default: []
  array :utility_bills, default: []
  file :electrical_distribution_schematic_diagram, :equipment_list_and_specification, default: nil
  object :user
  boolean :full_time_occupancy, :has_ac, :has_solar_pv, :has_dryer, default: nil
  boolean :draft, default: false
  string :owner_name, :owner_email, :contact_number, :zip, :locality,:electricity_consumption_unit,
         :natural_gas_unit, :water_unit,:full_time_occupancy, :floor_cieling_height,
         :avg_room_unit, :living_room_unit, :dining_room_unit, :total_house_unit,
         :floor_cieling_unit, :roof_length_unit, :roof_breadth_unit, :door_name, :solar_power_consumption_unit, default: nil
  string :country, default: 'Singapore'
  integer :property_sub_category_id, :suppliers_plan_id, :current_electricity_supplier_id, default: nil
  integer :adults, :children, :senior_citizens, :bedrooms, :bathrooms, :floors, :current_step,
          :ac_temperature, :floor_number, :ac_in_use, :people_at_home, :daily_dryer_usage, default: nil
  decimal :avg_room_size, :living_room_size, :dining_room_size, :total_house_size,
          :electricity_consumption, :water_consumption, :natural_gas_consumption, :duration_of_stay_year,
          :duration_of_stay_month, :ac_units, :roof_length, :roof_breadth,
          :supplier_electricity_rate, :solar_power_consumption, default: nil
  time :start_time, :end_time, :ac_start_time, :ac_stop_time, default: nil
  date :different_supplier_from, default: nil
  date :different_supplier_to, default: nil
  validates :owner_name, :owner_email, :zip, :locality,
            :property_sub_category_id, presence: true, unless: :draft?
  validates :adults, :children, :senior_citizens, :bedrooms, :bathrooms, :floors,
            :avg_room_size, :living_room_size, :dining_room_size, :total_house_size,
            :electricity_consumption, :water_consumption,
            :natural_gas_consumption, numericality: { greater_than_or_equal_to: 0.0 }, unless: :draft?

  def execute
    ActiveRecord::Base.transaction do
      property = user.properties.new(inputs.except(:energy_data, :electricity_consumption_equipments, :property_checklist,
                                                   :equipment_maintenances, :utility_bills, :renewable_energy_sources))
      return errors.merge! property.errors unless property.save
      create_energy_data(property)
      create_electricity_consumption_equipments(property)
      create_property_checklist(property)
      create_equipment_maintenance(property)
      create_renewable_energy_sources(property)
      create_utility_bills(property)
      raise ActiveRecord::Rollback if errors.present?
      property
    end
  end

  private

  # To create energy data for the property
  def create_energy_data(property)
    energy_outcome = Residential::EnergyData::CreateIntr.run(property: property, energy_data: energy_data)
    errors.merge! energy_outcome.errors unless energy_outcome.valid?
  end

  # To create electricity consumption equipments for the property
  def create_electricity_consumption_equipments(property)
    equipment_outcome = Residential::ElectricityConsumptionEquipment::CreateIntr.run(property: property,
                                                                        equipments: electricity_consumption_equipments)
    errors.merge! equipment_outcome.errors unless equipment_outcome.valid?
  end

  # To create energy saving checklist for the property
  def create_property_checklist(property)
    checklist_outcome = Residential::Checklist::CreateIntr.run(property: property, property_checklist: property_checklist)
    errors.merge! checklist_outcome.errors unless checklist_outcome.valid?
  end

  # Create equipment maintenance
  def create_equipment_maintenance(property)
    maintenance_outcome = Residential::EquipmentMaintenance::CreateIntr.run(property: property, equipment_maintenances: equipment_maintenances)
    errors.merge! maintenance_outcome.errors unless maintenance_outcome.valid?
  end

  # Create renewable energy sources
  def create_renewable_energy_sources(property)
    renewable_sources_outcome = Residential::RenewableEnergySource::CreateIntr.run(property: property, renewable_energy_sources: renewable_energy_sources)
    errors.merge! renewable_sources_outcome.errors unless renewable_sources_outcome.valid?
  end

  # To create past year's utility bills
  def create_utility_bills(property)
    utility_bills_outcome = Residential::UtilityBills::CreateIntr.run(property: property, utility_bills: utility_bills)
    errors.merge! utility_bills_outcome.errors unless utility_bills_outcome.valid?
  end

end
