class PropertyCategoriesController < BaseController

  before_action :set_category, only: [:get_sub_categories]

  def get_sub_categories
    @sub_categories = @category.property_sub_categories
    render partial: 'properties/sub_categories'
  end

  private

  def set_category
    @category = PropertyCategory.find_by(id: params[:id])
    return render('failure') unless @category
  end

end
