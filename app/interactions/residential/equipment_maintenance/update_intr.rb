# frozen_string_literal: true

class Residential::EquipmentMaintenance::UpdateIntr < ApplicationInteraction
  object :property
  array :equipment_maintenances

  validate :equipment_name_and_frequency

  def execute
    update_records, create_records = maintenance_data_collection
    return errors.merge! update_records.errors unless EquipmentMaintenance.update(update_records.keys, update_records.values)
    if create_records.present?
      maintenance_outcome = Residential::EquipmentMaintenance::CreateIntr.run(property: property, equipment_maintenances: create_records)
      errors.merge! maintenance_outcome.errors unless maintenance_outcome.valid?
    end
    property
  end

  private

  def maintenance_data_collection
    update_records = {}
    create_records = []
    equipment_maintenances.each do |equipment|
      data = { 'name' => equipment['name'], 'frequency' => equipment['frequency'],
                    'last_upgraded_month' => equipment['last_upgraded_month'], 'last_upgraded_year' => equipment['last_upgraded_year']}
      if equipment['id'].present?
        update_records.merge!(equipment['id'] => data)
      else
        create_records.push(data)
      end
    end
    return update_records, create_records
  end

  def equipment_name_and_frequency
    equipment_maintenances.each do |equipment_maintenance|
      equipment_maintenance = equipment_maintenance.with_indifferent_access
      return errors.add(:base, I18n.t('equipment_maintenances.name.cannot_blank')) if equipment_maintenance[:name].blank?
      return errors.add(:base, I18n.t('equipment_maintenances.frequency.greator_than_zero')) if equipment_maintenance[:frequency].to_f < 0
    end
  end
end
