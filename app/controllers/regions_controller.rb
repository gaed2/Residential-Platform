class RegionsController < BaseController

  before_action :set_region

  def get_cities
    @cities = @region.cities
    render partial: 'regions/cities'
  end

  private

  def set_region
    @region = params[:id].to_i > 0 ? Region.find_by(id: params[:id]) : Region.find_by(name: params[:id])
    return render_not_found_response(t('failure')) unless @region
  end

end
