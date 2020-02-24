ActiveAdmin.register SuppliersPlan do
  active_admin_import
  permit_params :name, :contract_duration, :plan_type, :price, :price_type, :electricity_supplier_id

  index download_links: [:csv]

  csv do
    column :id
    column("Retailer") { |supplier| supplier.electricity_supplier.name}
    column("Plan Name") { |supplier| supplier.name }
    column :plan_type
    column :price
    column :price_type
    column("Contract Duration") { |supplier| supplier.contract_duration }
    column :tariff_allow
  end

  collection_action :autocomplete_suppliers_plan_name, method: :get do
    return if params[:term].length < Constant::MINIMUM_CHARACTER_FOR_SEARCH
    plan_names = SuppliersPlan.select(:name).by_name(params[:term])
    render json: plan_names
  end

  collection_action :do_import, method: :post do
    csv_file = params[:active_admin_import_model][:file].read

    if csv_file.empty?
      flash[:alert] = "File is empty"
      redirect_back(fallback_location: import_admin_suppliers_plans_path) and return
    end

    imported_file_header = CSV.parse(csv_file, headers: true).headers
    
    if imported_file_header[1] != "Retailer"
      flash[:alert] = "Retailer column not found. Please use file from CSV link"
      redirect_back(fallback_location: import_admin_suppliers_plans_path) and return
    end

    CSV.parse(csv_file, headers: true) do |row|
      electricity_supplier = ElectricitySupplier.find_by(name: row['Retailer'])
      
      if electricity_supplier.nil?
        flash[:alert] = "Failed to find Supplier"
        redirect_back(fallback_location: import_admin_suppliers_plans_path) and return
      end

      next unless electricity_supplier
      supplier_plan_params = {
                               name: row['Plan Name'],
                               plan_type: SuppliersPlan.plan_types[row['Plan type']],
                               price_type: SuppliersPlan.price_types[row['Price type']],
                               tariff_allow: row['Tariff allow'],
                               contract_duration: row['Contract Duration'],
                               price: row['Price'],
                               electricity_supplier_id: electricity_supplier.id
                             }
      supplier_plan = SuppliersPlan.find_or_initialize_by(name: row['Plan Name'],
                                                          plan_type: row['Plan type'],
                                                          contract_duration: row['Contract duration'])
      supplier_plan.assign_attributes(supplier_plan_params)

      if supplier_plan.valid?
        supplier_plan.save!
        redirect_to admin_suppliers_plans_path, notice: "Import success!"
      else
        redirect_to import_admin_suppliers_plans_path, alert: "Import failure. Please check file format"
      end

    end
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
