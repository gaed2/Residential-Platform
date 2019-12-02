class BillCalculator::Residential
  # Estimate monthly bill in dollar depends on plan type (fixed or discount off)
  def self.estimated_monthly_bill(property, price, plan_type)
    return (price * property.avg_monthly_electricity_consumption).to_f / 100  if plan_type.try(:to_sym).eql?(:fixed)
    (property.energy_data.average(:cost).to_f * (1 - price.to_f / 100)).to_f / 100
  end

  # Estimate monthly bill in dollar for peak plans
  def self.estimated_peak_monthly_bill(property, peak_price, peak_price_type)
    if peak_price_type.try(:to_sym).eql?(:unit)
      avg_peak_consumption = property.avg_monthly_electricity_consumption * Constant::AVG_PEAK_CONSUMPTION
      (peak_price * avg_peak_consumption).to_f / 100
    else
      avg_peak_consumption = property.energy_data.average(:cost).to_f * Constant::AVG_PEAK_CONSUMPTION
      (avg_peak_consumption * (1 - peak_price.to_f / 100)).to_f / 100
    end
  end

  # Estimate monthly bill in dollar for peak off plans
  def self.estimated_peak_off_monthly_bill(property, peak_off_price, peak_off_price_type)
    if peak_off_price_type.try(:to_sym).eql?(:unit)
      avg_peak_off_consumption = property.avg_monthly_electricity_consumption * (1 - Constant::AVG_PEAK_CONSUMPTION)
      (peak_off_price * avg_peak_off_consumption).to_f / 100
    else
      avg_peak_off_consumption = property.energy_data.average(:cost).to_f * (1 - Constant::AVG_PEAK_CONSUMPTION)
      (avg_peak_off_consumption * (1 - peak_off_price.to_f / 100)).to_f / 100
    end
  end
end