require 'securerandom'
class JsonBuilder
  def initialize(property)
    @property = property
  end

  def property_data; end

  def energy_data; end

  def electricity_consumption_equipments; end

  def property_checklists; end

  def equipment_maintenances; end

  def past_year_utility_bills; end

  def renewable_energy_sources; end

  def recommendations; end

  def fetch_general_details; end

  def fetch_energy_data_details; end

  def fetch_checklist_details; end

  # def fetch_provided_documents; end

  def self.data_detail_actions
    instance_methods.grep(/fetch_*/).push(:recommendations)
  end

  def aggregate_json
    aggregated = self.class.instance_methods.grep(/fetch_*/).inject([]) do |agg, action|
      agg.push(action => send(action))
    end
    [aggregated.to_json, SecureRandom.hex]
  end
end
