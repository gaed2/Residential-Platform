class ElectricitySupplier < ApplicationRecord
  has_many :suppliers_plans, dependent: :destroy
  has_many :peak_and_off_peak_plans, dependent: :destroy
  has_many :properties, foreign_key: 'current_electricity_supplier_id', dependent: :destroy, inverse_of: :current_electricity_supplier

  scope :by_name, -> (name) { where('LOWER(name) ILIKE ?', "%#{name}%") }

  mount_uploader :logo, ElectricitySupplierLogoUploader

  def self.default_supplier_id
    find_by(name: 'SP Group')&.id
  end

end
