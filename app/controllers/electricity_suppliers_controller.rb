class ElectricitySuppliersController < BaseController

  before_action :set_property, only: [:suggestions, :retailers, :compare_plans]

  def suggestions
    @electricity_suppliers = ElectricitySupplier.pluck(:name, :id)
    @suggested_plans = SuppliersPlans::FilterIntr.run!(filter_params.merge(property: @property))
    return render partial: 'suggested_results', locals: {suggested_plans: @suggested_plans} if params[:column] && params[:order]
    respond_to do |format|
      format.js { render 'peak_and_off_peak_suggestions' if filter_params[:plan_type].to_sym.eql?(:peak_and_off_peak) }
      format.html
    end
  end

  def retailers
    @plans = @property.top_three_retailers
    @best_plan = @plans.first
  end

  def plans
    @suppliers = ElectricitySupplier.includes(:suppliers_plans, :peak_and_off_peak_plans)
  end

  def filter_plan
    electricity_supplier = ElectricitySupplier.find_by(id: params[:id])
    return render_not_found_response(t('failure')) unless electricity_supplier
    @plans = electricity_supplier.suppliers_plans
    render partial: 'electricity_suppliers/filtered_plans'
  end

  def fetch_plan_rate
    supplier_plan_rate = SuppliersPlan.find_by(id: params[:id])&.price || Constant::SP_GROUP_ELECTRICITY_RATE
    render json: {:rate => supplier_plan_rate}
  end

  def compare_plans
    plan = @property.compare_plan(params[:plan_id]).last
    render_success_response("", {
                                  name: plan.name,
                                  supplier_name: plan.electricity_supplier.name,
                                  plan_type: plan.plan_type&.titleize,
                                  plan_duration: "#{plan.contract_duration} months",
                                  rate: "#{plan.price} Cents/KWh",
                                  estimated_cost: "$#{plan.estimated_cost.round(2)}",
                                  estimated_bill: "$#{(@property.avg_monthly_electricity_bill - plan.estimated_cost.round).round(2)}"
                                }
                            )
  end

  private

  def set_property
    @property ||= current_user.properties.includes(:property_sub_category).find(params[:property_id])
  end

  def filter_params
    params.permit(:property_id, :average_monthly_consumption, :plan_type, :electricity_supplier_id, :column, :order)
  end
end