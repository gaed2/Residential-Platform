class HomesController < ApplicationController

  before_action :authenticate_user!
  
  def dashboard
    page = params[:page].to_i == 0 ? 1 : params[:page]
    @properties = current_user.properties.list
                                         .order(created_at: :desc)
                                         .includes(city: [:region], property_sub_category: [:property_category])
                                         .paginate(page: page, per_page: Constant::PROPERTY_PER_PAGE)
    @fixed_plans = SuppliersPlan.where(plan_type: "fixed")
                                .order(:price).first(3)
    @discounted_plans = SuppliersPlan.where(plan_type: "discount_off")
                                     .order(:price).first(3)
    @peakoffpeak_plans = PeakAndOffPeakPlan.order(:peak_price).first(3)
  end

  def drafts_only
    page = params[:page].to_i == 0 ? 1 : params[:page]
    @properties = current_user.properties.drafts_only
                                         .order(created_at: :desc)
                                         .includes(city: [:region], property_sub_category: [:property_category])
                                         .paginate(page: page, per_page: Constant::PROPERTY_PER_PAGE)
  end

end
