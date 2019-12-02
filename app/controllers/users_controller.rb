class UsersController < BaseController

  skip_before_action :authenticate_user!, only: [:check_email_uniqueness]

  def profile
    @user = current_user
  end

  # Update user profile
  def update
    outcome = Onboarding::UpdateUserIntr.run(user_params.merge(user: current_user))
    return render_success_response(t('user.profile_updated')) if outcome.valid?
    render_error_response(outcome.errors.full_messages)
  end

  # Email uniqueness
  def check_email_uniqueness
    return render_success_response(t('success')) unless User.exists?(email: params[:email].downcase)
    render_error_response(t('user.email_already_exist'))
  end

  def remove_avatar
    current_user.remove_avatar!
    current_user.save
    redirect_to profile_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :avatar, :phone_number)
  end

end