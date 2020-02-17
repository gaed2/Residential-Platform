class SuppliersPlan < ApplicationRecord
  belongs_to :electricity_supplier
  enum plan_type: %i[fixed discount_off]
  enum price_type: %i[percentage unit]

  scope :by_name, -> (name) { where('LOWER(name) ILIKE ?', "%#{name}%") }

  has_many :properties

  validates_uniqueness_of :name, scope: [:plan_type, :contract_duration]

  def price_in
    return '%' if percentage?
    I18n.t('price_unit')
  end

end
