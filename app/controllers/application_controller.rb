class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :logout_blocked_user, if: proc { current_user.try(:blocked?) }
  rescue_from ActiveRecord::RecordNotFound, with: :error_render_not_found
  rescue_from ActionController::InvalidAuthenticityToken, with: :error_invalid_token

  def render_unauthorized_error_response(message)
    render_response(message, 401)
  end

  def render_unconfirmed_error_response(message)
    render_response(message, 307)
  end

  def render_error_response(message)
    render_response(message, 400)
  end

  def render_success_response(message, data = {})
    render_response(message, 200, data)
  end

  def render_success_update_response(message, data = {})
    render_response(message, 204, data)
  end

  def render_not_found_response(message)
    render_response(message, 404)
  end

  def render_response(message, code, data = {})
    render json: { response: { message: message, data: data } }, status: code
  end

  def route_not_found
    render json: { message: I18n.t('api.application.no_route') + " #{params[:unmatched_route]}" }, status: 404
  end

  private

  def error_render_not_found
    message = t('record_not_found')
    return render_not_found_response(message) if request.format.json?
    flash[:error] = message
    redirect_to current_admin_user.present? ? admin_dashboard_path : root_path
  end

  def error_invalid_token
    message = t('invalid_token')
    return render_error_response(message) if request.format.json?
    flash[:error] = message
    redirect_to new_user_session_path
  end

  def logout_blocked_user
    sign_out current_user
  end

  def load_report_data
    @energy_save_recommendations = @property.energy_save_recommendation
    @top_three_retailers = @property.top_three_retailers
    @best_plan = @top_three_retailers.first
    @stats = "EnergySaving::#{@property.category_name}".classify.constantize.new(@property)
    @solar_pv = @property.solar_pv
    @yearly_saving_with_solar, @per_year_saving_with_solar = @stats.yearly_saving_with_solar_pv
    @yearly_saving_with_retailer_switch, @per_year_saving_with_retailer_switch = @stats.yearly_saving_with_retailer_switch
    @current_yearly_bills = @stats.current_yearly_bills
    @projected_bills_with_gaed = @stats.projected_bills_with_gaed
    @energy_breakdown = [
                          { name: 'Saving With Energy Retailer Switch', y: @yearly_saving_with_retailer_switch },
                          { name: 'New Bill With Both Solution', y: @projected_bills_with_gaed.sum.to_f }
                        ]
    @energy_breakdown.push({ name: 'Saving With Solar PV System', y: @yearly_saving_with_solar }) if @property.is_landed?
  end

end
