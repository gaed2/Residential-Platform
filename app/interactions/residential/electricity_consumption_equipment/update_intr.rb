# frozen_string_literal: true

class Residential::ElectricityConsumptionEquipment::UpdateIntr < ApplicationInteraction
  object :property
  array :equipments

  validate :equipment_data

  def execute
    update_records, create_records = equipment_data_collection
    return errors.merge! update_records.errors unless ElectricityConsumptionEquipment.update(update_records.keys, update_records.values)
    if create_records.present?
      equipment_outcome = Residential::ElectricityConsumptionEquipment::CreateIntr.run(property: property,
                                                                                       equipments: create_records)
      errors.merge! equipment_outcome.errors unless equipment_outcome.valid?
    end
    property
  end

  private

  def equipment_data_collection
    update_records = {}
    create_records = []
    equipments.each do |equipment|
      data = { 'name' => equipment['name'], 'equipment_type' => equipment['equipment_type'],
               'electricity_consumption' => equipment['electricity_consumption'], 'year_installed' => equipment['year_installed'],
               'location' => equipment['location'], 'quantity' => equipment['quantity'],
               'rating' => equipment['rating'], 'rated_kw' => equipment['rated_kw']
      }
      if equipment['id'].present?
        update_records.merge!(equipment['id'] => data)
      else
        create_records.push(data)
      end
    end
    return update_records, create_records
  end

  # To check name, type, cost and consumption of equipment
  def equipment_data
    equipments.each do |equipment|
      equipment = equipment.with_indifferent_access
      return errors.add(:base, I18n.t('equipment.name.cannot_blank')) if equipment[:name].blank?
      # TODO need to discuss
      # return errors.add(:base, I18n.t('equipment.type.cannot_blank')) if equipment[:equipment_type].blank?
      return errors.add(:base, I18n.t('energy_data.cost.greator_than_zero')) if equipment[:cost].to_f < 0
      return errors.add(:base, I18n.t('energy_data.consumption.greator_than_zero')) if equipment[:electricity_consumption].to_f < 0
    end
  end
end
