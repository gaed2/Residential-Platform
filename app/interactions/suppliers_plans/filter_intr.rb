class SuppliersPlans::FilterIntr < ApplicationInteraction
  string :plan_type, :electricity_supplier_id, default: nil
  object :property, class_name: 'Property'
  string :order, default: 'ASC'
  string :column, default: 'estimated_cost'

  def execute
    filter_plans
  end

  # TODO just for confirmation
  def execute2
    return filter_by_plan_type if plan_type.present?
    return electricity_supplier.suppliers_plans if electricity_supplier_id.present?
    SuppliersPlan.includes(:electricity_supplier).limit(Constant::TOP_PLANS_LIMIT)
  end

  private

  def filter_plans
    return peak_plans if plan_type && plan_type.to_sym.eql?(:peak_and_off_peak)
    avg_monthly_electricity_bill = property.avg_monthly_electricity_bill
    avg_monthly_electricity_consumption = property.avg_monthly_electricity_consumption
    current_regulated_rate = property.current_regulated_rate
    sql = ""
    sql << "select *,"
    sql << "(CASE
                 WHEN suppliers_plans.price_type = 0
                   THEN (#{avg_monthly_electricity_bill} - (#{avg_monthly_electricity_consumption*current_regulated_rate/100} * suppliers_plans.price/100))
                 ELSE (suppliers_plans.price/100*#{avg_monthly_electricity_consumption/100})
            END) as estimated_cost "
    sql << " from suppliers_plans"
    sql << condition if electricity_supplier_id.present? || plan_type.present?
    sql << " ORDER BY #{column} #{order}"
    sql << " LIMIT #{Constant::TOP_PLANS_LIMIT}"
    SuppliersPlan.find_by_sql(sql)
  end

  def condition
    return " where electricity_supplier_id = #{electricity_supplier_id} AND plan_type = #{SuppliersPlan.plan_types[plan_type]}" if plan_type.present? && electricity_supplier_id.present?
    return " where plan_type = #{SuppliersPlan.plan_types[plan_type]}" if plan_type.present?
    " where electricity_supplier_id = #{electricity_supplier_id}"
  end

  def peak_plans
    return PeakAndOffPeakPlan.includes(:electricity_supplier).limit(Constant::TOP_PLANS_LIMIT)if electricity_supplier_id.blank?
    electricity_supplier.peak_and_off_peak_plans.limit(Constant::TOP_PLANS_LIMIT)
  end

  def filter_by_plan_type
    top_plan_limit = Constant::TOP_PLANS_LIMIT
    if electricity_supplier_id.blank?
      return PeakAndOffPeakPlan.includes(:electricity_supplier).limit(top_plan_limit) if plan_type.to_sym.eql?(:peak_and_off_peak)
      SuppliersPlan.includes(:electricity_supplier).send(plan_type).limit(top_plan_limit)
    else
      return electricity_supplier.peak_and_off_peak_plans.limit(top_plan_limit) if plan_type.to_sym.eql?(:peak_and_off_peak)
      electricity_supplier.suppliers_plans.send(plan_type).limit(top_plan_limit)
    end
  end

  def electricity_supplier
    @electricity_supplier ||= ElectricitySupplier.includes(:suppliers_plans, :peak_and_off_peak_plans).find(electricity_supplier_id)
  end
end
