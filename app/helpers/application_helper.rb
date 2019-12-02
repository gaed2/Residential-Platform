module ApplicationHelper

  # User avatar
  def user_avatar(avatar)
    avatar.url(:thumb)
  end

  def size_unit
    t('size_unit')
  end

  def round_two(amount)
    amount.round(2)
  end

  def regulated_price
    @property.current_regulated_rate
  end

  def electricity_tarrif
    TariffRate.electricity.last
  end

  def water_tarrif
    TariffRate.water.last
  end

  def gas_tarrif
    TariffRate.gas.last
  end

  def rate_with_gst(cost, gst)
    (cost + (cost*gst)/100).round(2)
  end

end
