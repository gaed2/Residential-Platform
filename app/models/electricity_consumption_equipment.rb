class ElectricityConsumptionEquipment < ApplicationRecord
  belongs_to :property

  def data
    str = ""
    str << "#{quantity} x" if quantity
    str << " #{name}"
    str << " #{equipment_type} model" if equipment_type.present?
    str << " #{rating} rating" if rating
    str << " for #{location}" if location
    str << " installed in #{year_installed}" if year_installed
    str
  end

  # Equipment description
  def description
    str = ""
    str << " #{equipment_type} model" if equipment_type.present?
    str << " #{rating} rating" if rating
    str << " installed in #{year_installed}" if year_installed
    str
  end

  # If appliance installed before 2015
  def not_upgraded?
    year_installed < Constant::EQUIPMENT_VALIDITY_YEAR
  end

  # Any appliance before 2015 should have 1 start rating
  def star_rating
    return rating unless not_upgraded?
    Constant::DEFAULT_RATING
  end

end
