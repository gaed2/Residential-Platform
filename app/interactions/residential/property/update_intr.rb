# frozen_string_literal: true

class Residential::Property::UpdateIntr < ApplicationInteraction
  array :energy_data, default: []
  array :electricity_consumption_equipments, default: []
  array :property_checklist, default: []
  array :equipment_maintenances, default: []
  object :property
  string :owner_name, :owner_email, :contact_number, :zip, :locality,:electricity_consumption_unit,
         :natural_gas_unit, :water_unit, :floor_cieling_height, :avg_room_unit, :living_room_unit, :dining_room_unit,
         :total_house_unit, :floor_cieling_unit, :roof_length_unit, :roof_breadth_unit, :door_name, :solar_power_consumption_unit, default: nil
  string :country, default: 'Singapore'
  integer :current_electricity_supplier_id, default: -> { property.current_electricity_supplier_id }
  integer :property_sub_category_id, default: -> { property.property_sub_category_id }
  integer :suppliers_plan_id, default: -> { property.suppliers_plan_id }
  integer :adults, :children, :senior_citizens, :bedrooms, :bathrooms, :floors, :floor_number,
          :current_step, :duration_of_stay_year, :duration_of_stay_month,
          :ac_temperature, :ac_in_use, :people_at_home, :daily_dryer_usage, default: nil
  decimal :avg_room_size, :living_room_size, :dining_room_size, :total_house_size,
          :electricity_consumption, :water_consumption, :natural_gas_consumption,
          :ac_units, :roof_length, :roof_breadth, :supplier_electricity_rate, :solar_power_consumption, default: nil
  time :start_time, :end_time, :ac_start_time, :ac_stop_time, default: nil
  boolean :draft, default: -> { property.draft }
  boolean :full_time_occupancy , default: -> { property.full_time_occupancy }
  boolean :has_ac , default: -> { property.has_ac }
  boolean :has_solar_pv , default: -> { property.has_solar_pv }
  boolean :has_dryer , default: -> { property.has_dryer }

  validates :owner_name, :owner_email, :zip,
            :property_sub_category_id, presence: true, unless: :draft?
  validates :bedrooms, :bathrooms, :floors, :avg_room_size, :total_house_size, :electricity_consumption,
            :water_consumption, numericality: { greater_than_or_equal_to: 0.0 }, unless: :draft?

  def execute
    ActiveRecord::Base.transaction do
      assign_attrs property, inputs.keys - %i[property energy_data electricity_consumption_equipments property_checklist equipment_maintenances]
      return errors.merge! property.errors unless property.save
      # TODO
      #update_energy_data(property) if energy_data.present?
      #update_electricity_consumption_equipments(property) if electricity_consumption_equipments.present?
      #update_property_checklist(property) if property_checklist.present?
      #update_equipment_maintenance(property) if equipment_maintenances.present?
      raise ActiveRecord::Rollback if errors.present?
    end
  end

  private

  # To update energy data for the property
  def update_energy_data(property)
    energy_outcome = Residential::EnergyData::UpdateIntr.run(property: property, energy_data: energy_data)
    errors.merge! energy_outcome.errors unless energy_outcome.valid?
  end

  # To update electricity consumption equipments for the property
  def update_electricity_consumption_equipments(property)
    equipment_outcome = Residential::ElectricityConsumptionEquipment::UpdateIntr.run(property: property,
                                                                        equipments: electricity_consumption_equipments)
    errors.merge! equipment_outcome.errors unless equipment_outcome.valid?
  end

  # To update energy saving checklist for the property
  def update_property_checklist(property)
    checklist_outcome = Residential::Checklist::UpdateIntr.run(property: property, property_checklist: property_checklist)
    errors.merge! checklist_outcome.errors unless checklist_outcome.valid?
  end

  def update_equipment_maintenance(property)
    maintenance_outcome = Residential::EquipmentMaintenance::UpdateIntr.run(property: property, equipment_maintenances: equipment_maintenances)
    errors.merge! maintenance_outcome.errors unless maintenance_outcome.valid?
  end
end
