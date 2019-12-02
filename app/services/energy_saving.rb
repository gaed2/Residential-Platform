class EnergySaving

  def initialize(property)
    @property = property
    @avg_monthly_consumption = @property.avg_monthly_electricity_consumption
    @electricity_rate = @property.current_regulated_rate/100
    @roof_length = @property.roof_length || Constant::DEFAULT_ROOF_LENGTH
    @roof_width = @property.roof_breadth || Constant::DEFAULT_ROOF_WIDTH
    @solar = SolarPvSystem.last
    @tarriff_rate = @solar.electricity_retailer_tariff
    @number_of_years = Constant::TOTAL_BILL_SAVING_YEARS - 1
    @tarriff_fluctuation = Constant::TARRIF_RATE_FLUCTUATION
    @energy_fluctuation = Constant::ENERGY_FLUCTUATION
  end

end