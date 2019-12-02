ActiveAdmin.register PropertySubCategory do
  permit_params :property_category_id, :name
  includes :property_category

  collection_action :autocomplete_property_sub_category_name, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    property_sub_category_names = PropertySubCategory.select(:name).by_name(params[:term])
    render json: property_sub_category_names
  end

  filter :property_category

  filter :name_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/property_sub_categories/autocomplete_property_sub_category_name'
          }
  }, label: 'Name contains', required: false

  index do
    column :id
    column :name
    column :property_category
    actions
  end

  show do
    attributes_table do
      row :name
      row :property_category
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :property_category
    end
    f.actions
  end
end