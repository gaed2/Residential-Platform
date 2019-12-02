class SolarPvSystem < ApplicationRecord

  # Solar PV
  def reference_yield_min
    (pre_selected_min/size_min).round(2)
  end

  def reference_yield_max
    (pre_selected_max/size_max).round(2)
  end

  # Roof length available
  def length_available(length)
    (length - scdf_setback*2).round(2)
  end

  # Roof width available
  def width_available(width)
    (width - scdf_setback*2).round(2)
  end

  def roof_available(length, width)
    (length_available(length) * width_available(width)).round(2)
  end

  def actual_roof_available(length, width)
    (length * width).round(2)
  end

  def estimated_system_size_min(length, width, type)
    return (actual_roof_available(length, width)*reference_yield_min/1000).round(2) if type =='actual'
    (roof_available(length, width)*reference_yield_min/1000).round(2)
  end

  def estimated_system_size_max(length, width, type)
    return (actual_roof_available(length, width)*reference_yield_max/1000).round(2) if type =='actual'
    (roof_available(length, width)*reference_yield_max/1000).round(2)
  end

  def daily_energy_generated_min(length, width, type)
    (estimated_system_size_min(length, width, type)*sun_peak_hrs_daily*actual_system_efficiency/100).round(2)
  end

  def daily_energy_generated_max(length, width, type)
    (estimated_system_size_max(length, width, type)*sun_peak_hrs_daily*actual_system_efficiency/100).round(2)
  end

  def monthly_energy_generated(length, width)
    ((daily_energy_generated_min(length, width, 'actual')*365)/12).round(2)
  end

  def monthly_saving(length, width)
    (monthly_energy_generated(length, width)*electricity_retailer_tariff).round(2)
  end

end
