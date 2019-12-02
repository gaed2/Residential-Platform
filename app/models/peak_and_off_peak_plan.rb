class PeakAndOffPeakPlan < ApplicationRecord
  belongs_to :electricity_supplier
  enum plan_type: %i[fixed discount_off]
  enum peak_price_type: %i[percentage unit], _prefix: true
  enum peak_off_price_type: %i[percentage unit], _prefix: true

  def peak_duration
    "#{peak_start.strftime(Constant::HOME_TIME_FORMAT)} to #{peak_end.strftime(Constant::HOME_TIME_FORMAT)}" if peak_start && peak_end
  end

  def peak_off_duration
    "#{peak_off_start.strftime(Constant::HOME_TIME_FORMAT)} to #{peak_off_end.strftime(Constant::HOME_TIME_FORMAT)}" if peak_off_start && peak_off_end
  end

  def peak_price_in
    return '%' if peak_price_type_percentage?
    I18n.t('price_unit')
  end

  def peak_off_price_in
    return '%' if peak_off_price_type_percentage?
    I18n.t('price_unit')
  end
end