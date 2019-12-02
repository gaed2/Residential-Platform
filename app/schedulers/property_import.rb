require 'sidekiq'
require 'sidekiq-scheduler'

class PropertyImport
  include Sidekiq::Worker

  def perform
    BlockchainInteraction.post_and_update
  end
end
