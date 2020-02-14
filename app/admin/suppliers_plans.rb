ActiveAdmin.register SuppliersPlan do
  active_admin_import
  permit_params :name, :contract_duration, :plan_type, :price, :price_type, :electricity_supplier_id

  index download_links: [:csv]

  collection_action :autocomplete_suppliers_plan_name, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    plan_names = SuppliersPlan.select(:name).by_name(params[:term])
    render json: plan_names
  end

  collection_action :do_import, method: :post do
    csv_file = params[:active_admin_import_model][:file].read
    CSV.parse(csv_file, headers: true) do |row|
      electricity_supplier = ElectricitySupplier.find_by(name: row['Retailer'])
      next unless electricity_supplier
      supplier_plan_params = {
                               name: row['Plan Name'],
                               contract_duration: row['Contract Duration'],
                               price: row['Price'],
                               electricity_supplier_id: electricity_supplier.id
                             }
      supplier_plan = SuppliersPlan.find_or_initialize_by(name: row['Plan Name'])
      supplier_plan.assign_attributes(supplier_plan_params)
      supplier_plan.save
    end
    flash[:notice] = "CSV imported successfully!"
    redirect_to action: :index
  end

  filter :name_contains, input_html: {
          class: 'autocomplete-filter',
          data: {
            url: '/admin/suppliers_plans/autocomplete_suppliers_plan_name'
          }
  }, label: 'Name contains', required: false

  filter :plan_type, as: :select
  filter :price_type, as: :select
  filter :electricity_supplier, as: :select

  SUPPLIER_PLAN_COLUMNS = %i[name contract_duration plan_type price price_type electricity_supplier].freeze

  index do
    column :id
    (SUPPLIER_PLAN_COLUMNS - %i[contract_duration price]).each do |col|
      column col
    end
    column :price do |supplier_plan|
      "#{supplier_plan.price} #{supplier_plan.price_in}"
    end
    column 'Contract Duration(in months)' do |supplier_plan|
      supplier_plan.contract_duration
    end
    actions
  end

  show do
    attributes_table do
      (SUPPLIER_PLAN_COLUMNS - %i[contract_duration price]).each do |col|
        row col
      end
      row :price do |supplier_plan|
        "#{supplier_plan.price} #{supplier_plan.price_in}"
      end
      row 'Contract Duration(in months)' do |supplier_plan|
        supplier_plan.contract_duration
      end
    end
  end

  form do |f|
    f.inputs do
      f.input :electricity_supplier
      f.input :name
      f.input :contract_duration, label: 'Contract Duration(in months)'
      f.input :plan_type
      f.input :price_type, as: :select
      f.input :price
    end
    f.actions
  end
end
