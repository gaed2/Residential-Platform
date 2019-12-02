# frozen_string_literal: true

class Residential::EquipmentMaintenance::CreateIntr < ApplicationInteraction
  object :property
  array :equipment_maintenances

  validate :equipment_name_and_frequency

  def execute
    maintenances = property.equipment_maintenances.build(equipment_maintenances)
    return errors.merge! maintenances.errors unless maintenances.map(&:save)
    maintenances
  end

  private

  def equipment_name_and_frequency
    equipment_maintenances.each do |equipment_maintenance|
      equipment_maintenance = equipment_maintenance.with_indifferent_access
      return errors.add(:base, I18n.t('equipment_maintenances.name.cannot_blank')) if equipment_maintenance[:name].blank?
      return errors.add(:base, I18n.t('equipment_maintenances.frequency.greator_than_zero')) if equipment_maintenance[:frequency].to_f < 0
    end
  end
end
