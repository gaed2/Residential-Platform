ActiveAdmin.register ElectricitySupplier do
  permit_params :name, :logo, :website_link
  collection_action :autocomplete_electricity_supplier_name, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    supplier_names = ElectricitySupplier.select(:name).by_name(params[:term])
    render json: supplier_names
  end

  filter :name_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/electricity_suppliers/autocomplete_electricity_supplier_name'
          }
  }, label: 'Name contains', required: false

  index do
    column :id
    column :name
    column :logo do |electricity_supplier|
      image_tag electricity_supplier.logo.url
    end
    column :website_link do |electricity_supplier|
      link_to electricity_supplier.website_link, electricity_supplier.website_link, target: '_blank'
    end
    actions
  end

  show do
    attributes_table do
      row :name
      row :logo do |electricity_supplier|
        image_tag electricity_supplier.logo.url
      end
      row :website_link do |electricity_supplier|
        link_to electricity_supplier.website_link, electricity_supplier.website_link, target: '_blank'
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :name
      f.input :logo
      f.input :website_link
    end
    f.actions
  end
end
