class PropertyCategory < ApplicationRecord
  has_many :property_sub_categories, dependent: :destroy

  mount_uploader :icon, PropertyCategoryIconUploader
end
