class BlockchainDatum < ApplicationRecord
  acts_as_paranoid

  # Associations
  # belongs_to :property

  # Validations
  validates :uuid, :data_hash, :data_type, :entity_id, :entity_type, :data_tab, presence: true
  # validates :property, presence: true
  validates_uniqueness_of :data_hash, { scope: [:entity_id, :entity_type] }

  enum status: ['inprogress', 'success', 'failed', 'timeout']
end
