class Residential::ReportsController < BaseController

  before_action :set_property, only: %w[generate audit]
  before_action :load_report_data, only: %w[generate audit]
  before_action :check_property_owner, only: %w[generate audit]

  def audit
  end

  def generate
    respond_to do |format|
      format.pdf do
        render pdf: "Report_#{@property.id}",
        margin: { top: 10, left: 12, right: 12 },
        layout: 'layouts/report.haml',
        header: { html: { template: '/residential/reports/header.haml' } },
        footer: { center: '[page]' },
        disable_javascript: false,
        javascript_delay: 2000
      end
    end
  end

  private

  def set_property
    @property ||= current_user.properties.includes(:energy_data, :electricity_consumption_equipments, :property_checklists,
                                                               property_sub_category: :property_category).find(params[:property_id] || params[:id])
  end

  # Check if user property owner
  def check_property_owner
    return redirect_to root_path unless current_user.id == @property.user_id
  end

end
