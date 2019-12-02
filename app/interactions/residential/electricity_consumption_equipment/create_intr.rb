# frozen_string_literal: true

class Residential::ElectricityConsumptionEquipment::CreateIntr < ApplicationInteraction
  object :property
  array :equipments

  validate :equipment_data

  def execute
    equipment = property.electricity_consumption_equipments.build(equipments)
    return errors.merge! equipment.errors unless equipment.map(&:save)
    equipment
  end

  private

  # To check name, type, cost and consumption of equipment
  def equipment_data
    equipments.each do |equipment|
      equipment = equipment.with_indifferent_access
      return errors.add(:base, I18n.t('equipment.name.cannot_blank')) if equipment[:name].blank?
      # TODO Need to discuss
      #return errors.add(:base, I18n.t('equipment.type.cannot_blank')) if equipment[:equipment_type].blank?
      return errors.add(:base, I18n.t('energy_data.cost.greator_than_zero')) if equipment[:cost].to_f < 0
      return errors.add(:base, I18n.t('energy_data.consumption.greator_than_zero')) if equipment[:electricity_consumption].to_f < 0
    end
  end
end
