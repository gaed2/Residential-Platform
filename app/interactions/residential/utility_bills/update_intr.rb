# frozen_string_literal: true

class Residential::UtilityBills::UpdateIntr < ApplicationInteraction
  object :property
  array :utility_bills

  def execute
    utility_bill = property.past_year_utility_bills.build(utility_bills)
    return errors.merge! utility_bill.errors unless utility_bill.map(&:save)
    utility_bill
  end

end
