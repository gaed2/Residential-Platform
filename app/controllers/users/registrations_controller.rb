class Users::RegistrationsController < Devise::RegistrationsController

  # POST /resource
  def create
    outcome = Onboarding::CreateUserIntr.run(sign_up_params)
    if outcome.valid?
      resource = outcome.result
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
      else
        expire_data_after_sign_in!
      end
      render_success_response(t('devise.confirmation_email_sent'))
    else
      self.resource = resource_class.new sign_up_params
      self.resource.errors[:base] << outcome.errors.full_messages.to_sentence
      render_error_response(self.resource.errors[:base]&.first)
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end

end
