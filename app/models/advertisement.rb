class Advertisement < ApplicationRecord
  mount_uploader :image, ImageUploader

  scope :by_company_name, ->(company_name) { where('LOWER(company_name) ILIKE ?', "%#{company_name}%") }

  def self.random_ad
    where('image is not null').order("RANDOM()").first
  end

end
