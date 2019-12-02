# frozen_string_literal: true

class Residential::EnergyData::UpdateIntr < ApplicationInteraction

  object :property
  array :energy_data

  validate :cost_and_energy_consumption

  def execute
    ActiveRecord::Base.transaction do
      update_records, create_records = energy_data_collection
      return errors.merge! update_records.errors unless EnergyDatum.update(update_records.keys, update_records.values)
      if create_records.present?
        energy_outcome = Residential::EnergyData::CreateIntr.run(property: property, energy_data: create_records)
        errors.merge! energy_outcome.errors unless energy_outcome.valid?
      end
      raise ActiveRecord::Rollback if errors.present?
    end
    property
  end

  private

  def update_attrs
    property.energy_data.each_with_index do |energy_datum, index|
      energy_datum.assign_attributes(energy_data[index])
    end
  end

  def energy_data_collection
    update_records = {}
    create_records = []
    energy_data.each do |data|
      data_hash = {'cost' => data['cost'], 'month' => data['month'], 'year' => data['year'],
                   'energy_consumption' => data['energy_consumption']}
      if data['id'].present?
        update_records.merge!(data['id'] => data_hash )
      else
        create_records.push(data_hash)
      end
    end
    return update_records, create_records
  end

  # To check numericality of cost and consumption
  def cost_and_energy_consumption
    energy_data.each do |data|
      return errors.add(:base, I18n.t('energy_data.cost.greator_than_zero')) if data[:cost].to_f < 0
      return errors.add(:base, I18n.t('energy_data.consumption.greator_than_zero')) if data[:energy_consumption].to_f < 0
    end
  end
end
