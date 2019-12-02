class Users::PasswordsController < Devise::PasswordsController

  before_action :set_user, only: [:create]
  before_action :flash_clear, only: [:edit]

  def create
    self.resource = resource_class.send_reset_password_instructions(resource_params)

    return render_success_response(t('devise.password_reset_link_sent')) if successfully_sent?(resource)
    render_error_response(resource.errors.full_messages)
  end

  # Update password
  def update
    # change password
    if user_signed_in?
      return render_error_response(t('user.incorrect_current_password')) if !current_user.valid_password?(params[:user][:current_password])
      return render_success_response(t('user.reset_password_successfully')) if current_user.update_with_password(user_params)
      render_error_response(current_user.errors.full_messages)
    else
      # reset password by using token
      super
    end
  end

  private

  def after_resetting_password_path_for(resource)
    new_user_session_path
  end
  
  def flash_clear
    flash.clear
  end

  def set_user
    user = User.find_by(email: params[:user][:email])
    return render_not_found_response(t('user.email_not_found')) unless user
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation, :current_password)
  end

end