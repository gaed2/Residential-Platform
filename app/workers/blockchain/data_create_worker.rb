require 'open-uri'
class Blockchain::DataCreateWorker
  include Sidekiq::Worker
  sidekiq_options retry: 5, dead: false

  def perform(property_id, current_tab = nil)
    property = Property.find_by(id: property_id)
    return unless property
    DataEncryptor::DataSaver.process_and_save(property, current_tab)
  end
end
