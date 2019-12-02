ActiveAdmin.register SolarPvSystem do

  permit_params :pre_selected_min, :pre_selected_max, :size_min,
                :size_max, :scdf_setback, :avg_daily_isolation,
                :sun_peak_hrs_daily, :actual_system_efficiency,
                :market_price_min, :market_price_max,
                :current_tariff, :electricity_retailer_tariff

  index do
    column :id
    column :pre_selected_min
    column :pre_selected_max
    column :size_min
    column :size_max
    column :scdf_setback
    column :avg_daily_isolation
    column :sun_peak_hrs_daily
    column :actual_system_efficiency
    column :market_price_min
    column :market_price_max
    column :current_tariff
    column :electricity_retailer_tariff
    actions
  end

  show do
    attributes_table do
      row :pre_selected_min
      row :pre_selected_max
      row :size_min
      row :size_max
      row :scdf_setback
      row :avg_daily_isolation
      row :sun_peak_hrs_daily
      row :actual_system_efficiency
      row :market_price_min
      row :market_price_max
      row :current_tariff
      row :electricity_retailer_tariff
    end
  end

  form do |f|
    f.inputs do
      f.input :pre_selected_min
      f.input :pre_selected_max
      f.input :size_min
      f.input :size_max
      f.input :scdf_setback
      f.input :avg_daily_isolation
      f.input :sun_peak_hrs_daily
      f.input :actual_system_efficiency
      f.input :market_price_min
      f.input :market_price_max
      f.input :current_tariff
      f.input :electricity_retailer_tariff
    end
    f.actions
  end
end
