# frozen_string_literal: true

class Residential::RenewableEnergySource::CreateIntr < ApplicationInteraction
  object :property
  array :renewable_energy_sources

  validate :renewable_energy_source_name_and_type

  def execute
    energy_sources = property.renewable_energy_sources.build(renewable_energy_sources)
    return errors.merge! energy_sources.errors unless energy_sources.map(&:save)
    energy_sources
  end

  private

  def renewable_energy_source_name_and_type
    renewable_energy_sources.each do |energy_source|
      energy_source = energy_source.with_indifferent_access
      return errors.add(:base, I18n.t('renewable_energy_source.name.cannot_blank')) if energy_source[:name].blank?
    end
  end
end
