# frozen_string_literal: true

class Residential::RenewableEnergySource::UpdateIntr < ApplicationInteraction
  object :property
  array :renewable_energy_sources

  validate :resource_name

  def execute
    update_records, create_records = renewable_energy_sources_data
    return errors.merge! update_records.errors unless RenewableEnergySource.update(update_records.keys, update_records.values)
    if create_records.present?
      renewable_energy_source_outcome = Residential::RenewableEnergySource::CreateIntr.run(property: property, renewable_energy_sources: create_records)
      errors.merge! renewable_energy_source_outcome.errors unless renewable_energy_source_outcome.valid?
    end
    property
  end

  private

  def renewable_energy_sources_data
    update_records = {}
    create_records = []
    renewable_energy_sources.each do |energy_source|
      data = {'name' => energy_source['name'], 'unit' => energy_source['unit']}
      if energy_source['id'].present?
        update_records.merge!(energy_source['id'] => data)
      else
        create_records.push(data)
      end
    end
    return update_records, create_records
  end

  def resource_name
    renewable_energy_sources.each do |energy_source|
      energy_source = energy_source.with_indifferent_access
      return errors.add(:base, I18n.t('renewable_energy_source.name.cannot_blank')) if energy_source[:name].blank?
    end
  end
end
