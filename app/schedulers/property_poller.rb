require 'sidekiq'
require 'sidekiq-scheduler'

class PropertyPoller
  include Sidekiq::Worker

  def perform
    BlockchainInteraction.poll_and_update
  end
end
