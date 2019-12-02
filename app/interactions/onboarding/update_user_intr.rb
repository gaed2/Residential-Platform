# frozen_string_literal: true

class Onboarding::UpdateUserIntr < ApplicationInteraction
  object :user, class: 'User', presence: true
  string :first_name, :last_name, :phone_number
  validates :first_name, :last_name, presence: true
  validate :validate_first_name, :validate_last_name
  file :avatar, default: nil

  def execute
    assign_attrs user, %i[first_name last_name avatar phone_number]
    errors.merge! user.errors unless user.save
    user
  end

  private

  def validate_first_name
    errors.add(:base, I18n.t('user.incorrect_first_name_format')) unless first_name.match(Constant::USER_NAME_FORMAT)
  end

  def validate_last_name
    errors.add(:base, I18n.t('user.incorrect_last_name_format')) unless last_name.match(Constant::USER_NAME_FORMAT)
  end

end
