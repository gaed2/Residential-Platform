ActiveAdmin.register TariffRate do

  permit_params :tariff_type, :name, :rate, :rate2, :gst, :valid_from,
                :valid_to, :cost_per_unit, :water_consumption_limit

  index do
    column :name
    column :rate
    column :pre_selected_max
    actions
  end

  show do
    attributes_table do
      row :name
      row :rate
      row :rate2
      row :gst
      row :valid_from
      row :valid_to
      row :cost_per_unit
      row :water_consumption_limit
    end
  end

  form do |f|
    f.inputs do
      f.input :tariff_type
      f.input :name
      f.input :rate
      f.input :rate2
      f.input :gst
      f.input :valid_from
      f.input :valid_to
      f.input :cost_per_unit
      f.input :water_consumption_limit
    end
    f.actions
  end
end