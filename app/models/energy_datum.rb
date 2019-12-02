class EnergyDatum < ApplicationRecord
  belongs_to :property

  scope :ordered_by_date, -> { order(year: :asc, month: :asc) }

  def cost_in_dollar
    cost.to_f / 100
  end

end
