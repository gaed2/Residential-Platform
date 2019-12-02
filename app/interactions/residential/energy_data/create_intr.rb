# frozen_string_literal: true

class Residential::EnergyData::CreateIntr < ApplicationInteraction
  object :property
  array :energy_data

  validate :cost_and_energy_consumption
  set_callback :execute, :before, -> {energy_data_params}

  def execute
    if @energy_data_arr.present?
      data = property.energy_data.build(@energy_data_arr)
      return errors.merge! data.errors unless data.map(&:save)
      data
    end 
  end

  private

  # Energy Data
  def energy_data_params
    @energy_data_arr = []
    energy_data.each do |data|
      @energy_data_arr << data unless property.energy_data.exists?(year: data['year'], month: data['month'])
    end
    @energy_data_arr
  end

  # To check numericality of cost and consumption
  def cost_and_energy_consumption
    energy_data.each do |data|
      data = data.with_indifferent_access
      return errors.add(:base, I18n.t('energy_data.cost.greator_than_zero')) if data[:cost].to_f < 0
      return errors.add(:base, I18n.t('energy_data.consumption.greator_than_zero')) if data[:energy_consumption].to_f < 0
    end
  end
end
