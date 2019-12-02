ActiveAdmin.register Advertisement do
  permit_params :company_name, :image, :link, :description

  collection_action :autocomplete_advertisement_company_name, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    company_names = Advertisement.select(:company_name).by_company_name(params[:term])
    render json: company_names
  end

  filter :property_category

  filter :company_name_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/advertisements/autocomplete_advertisement_company_name'
          }
  }, label: 'Company Name contains', required: false

  index do
    column :id
    column :company_name
    column :image do |advertisement|
      image_tag advertisement.image.url if advertisement.image.present?
    end
    column :link do |advertisement|
      link_to advertisement.link, advertisement.link, target: '_blank'
    end
    column :description
    actions
  end

  show do
    attributes_table do
      row :company_name
      row :image do |advertisement|
        image_tag advertisement.image.url if advertisement.image.present?
      end
      row :link do |advertisement|
        link_to advertisement.link, advertisement.link, target: '_blank'
      end
      row :description
    end
  end
end
