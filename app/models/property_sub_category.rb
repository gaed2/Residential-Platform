class PropertySubCategory < ApplicationRecord
  belongs_to :property_category
  has_many :properties, dependent: :destroy

  scope :by_name, -> (name) { where('LOWER(name) ILIKE ?', "%#{name}%") }
end
