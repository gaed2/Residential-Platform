class EnergySaving::Residential < EnergySaving

  # Yearly saving solar solution
  def yearly_saving_with_solar_pv
    tariff_rate = @tarriff_rate
    monthly_energy = @solar.monthly_energy_generated(@roof_length, @roof_width)
    monthly_saving = monthly_energy*tariff_rate
    yearly_saving = monthly_saving*12
    total_yearly_saving = yearly_saving
    per_year_saving_arr = [yearly_saving.round(2)]
    @number_of_years.times do
      monthly_energy = (monthly_energy*@energy_fluctuation)/100
      tariff_rate = (tariff_rate*@tarriff_fluctuation)/100
      new_year_save = monthly_energy*tariff_rate*12
      per_year_saving_arr << new_year_save.round(2)
      total_yearly_saving += new_year_save
    end
    return total_yearly_saving.round(2), per_year_saving_arr
  end

  # Yearly saving switching retailer
  def yearly_saving_with_retailer_switch
    tariff_rate = @tarriff_rate
    electricity_rate = @electricity_rate
    monthly_saving = (electricity_rate - @tarriff_rate)*@avg_monthly_consumption
    yearly_saving = monthly_saving*12
    total_yearly_saving = yearly_saving
    per_year_saving_arr = [yearly_saving.round(2).to_f]
    @number_of_years.times do
      electricity_rate = (electricity_rate*@tarriff_fluctuation)/100
      tariff_rate = (tariff_rate*@tarriff_fluctuation)/100
      new_year_save = ((electricity_rate - tariff_rate)*@avg_monthly_consumption)*12
      per_year_saving_arr << new_year_save.round(2).to_f
      total_yearly_saving += new_year_save
    end
    return total_yearly_saving.round(2).to_f, per_year_saving_arr
  end

   # Yearly saving with gaed solution
  def yearly_saving_with_gaed_solution
    tariff_rate = @tarriff_rate
    monthly_energy_generated = @solar.monthly_energy_generated(@roof_length, @roof_width)
    monthly_saving = (avg_monthly_consumption - monthly_energy_generated)*tariff_rate
    yearly_saving = monthly_saving*12
    total_yearly_saving = yearly_saving
    per_year_saving_arr = [total_yearly_saving.round(2).to_f]
    @number_of_years.times do
      monthly_energy_generated = (monthly_energy_generated*@energy_fluctuation)/100
      tariff_rate = (tariff_rate*@tarriff_fluctuation)/100
      new_yearly_saving = ((avg_monthly_consumption - monthly_energy_generated)*tariff_rate)*12
      per_year_saving_arr << new_yearly_saving.round(2).to_f
      total_yearly_saving += new_yearly_saving
    end
    return total_yearly_saving.round(2), per_year_saving_arr
  end

  # Current yearly bill for 25 years
  def current_yearly_bills
    avg_monthly_consumption = @avg_monthly_consumption
    electricity_rate = @electricity_rate
    yearly_bill = (electricity_rate*avg_monthly_consumption)*12
    per_year_bill = [yearly_bill.round(2).to_f]
    @number_of_years.times do
      electricity_rate = (electricity_rate*@tarriff_fluctuation)/100
      new_yearly_bill = (electricity_rate*avg_monthly_consumption)*12
      per_year_bill.push(new_yearly_bill.round(2).to_f)
    end
    per_year_bill
  end

  # Current yearly bill for 25 years
  def projected_bills_with_gaed
    avg_monthly_consumption = @avg_monthly_consumption
    electricity_rate = @electricity_rate
    monthly_energy_generated = @solar.monthly_energy_generated(@roof_length, @roof_width)
    yearly_bill = ((avg_monthly_consumption - monthly_energy_generated)*@electricity_rate)*12
    per_year_bill = [yearly_bill.round(2).to_f]
    @number_of_years.times do
      electricity_rate = (electricity_rate*@tarriff_fluctuation)/100
      monthly_energy_generated = (monthly_energy_generated*@energy_fluctuation)/100
      new_yearly_bill = ((avg_monthly_consumption - monthly_energy_generated)*electricity_rate)*12
      per_year_bill.push(new_yearly_bill.round(2).to_f)
    end
    per_year_bill
  end

  # Total bill saving with GAED
  def total_bill_saving
    curre_bill = current_yearly_bills.sum
    projected_bill = projected_bills_with_gaed.sum
    (((curre_bill - projected_bill)/curre_bill)*100).round(2)
  end

  # Total carbon offset
  def carbon_offset
    curre_bill = current_yearly_bills.sum
    projected_bill = projected_bills_with_gaed.sum
    ((curre_bill - projected_bill)*Constant::CARBON_RATIO).round(2)
  end

end
