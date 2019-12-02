# frozen_string_literal: true

class Onboarding::CreateUserIntr < ApplicationInteraction
  string :email, :password, :password_confirmation, :first_name, :last_name
  validates :email, :password, :password_confirmation, :first_name, :last_name, presence: true
  validate :validate_email_uniqueness, :validate_first_name, :validate_last_name

  def execute
    user = User.new(inputs.except(:email))
    user.email = email.downcase
    errors.merge! user.errors unless user.save
    user
  end

  private

  def validate_email_uniqueness
    errors.add(:base, I18n.t('user.email_already_exist')) if User.exists?(email: email.downcase)
  end

  def validate_first_name
    errors.add(:base, I18n.t('user.incorrect_first_name_format')) unless first_name.match(Constant::USER_NAME_FORMAT)
  end

  def validate_last_name
    errors.add(:base, I18n.t('user.incorrect_last_name_format')) unless last_name.match(Constant::USER_NAME_FORMAT)
  end

end
