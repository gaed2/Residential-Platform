class Users::SessionsController < Devise::SessionsController

  def create
    user = User.find_by(email: params[:user][:email].try(:downcase))
    return render_error_response(t('user.email_or_password_invalid')) if user.blank? || !user.valid_password?(params[:user][:password])
    return render_error_response(t('user.blocked_message', admin_email: Figaro.env.ADMIN_EMAIL)) if user.blocked?
    return render_error_response(t('user.please_confirm_email_address')) if !user.confirmed?
    super
  end

  private
  def after_sign_out_path_for(resource)
    new_user_session_path
  end

end
