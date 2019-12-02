class Users::ConfirmationsController < Devise::ConfirmationsController

  # POST /resource/confirmation
  def create
    self.resource = resource_class.send_confirmation_instructions(resource_params)
    yield resource if block_given?
    return render_success_response(t('devise.password_reset_link_sent')) if successfully_sent?(resource)
    render_error_response(resource.errors.full_messages)
  end

  private

  def after_confirmation_path_for(resource_name, resource)
    new_user_session_path
  end

end
