class CreateSolarPvSystems < ActiveRecord::Migration[5.1]
  def change
    create_table :solar_pv_systems do |t|
      t.integer :property_category_id
      t.float :pre_selected_min
      t.float :pre_selected_max
      t.float :size_min
      t.float :size_max
      t.float :scdf_setback
      t.float :avg_daily_isolation
      t.float :sun_peak_hrs_daily
      t.float :actual_system_efficiency
      t.float :market_price_min
      t.float :market_price_max
      t.float :current_tarrif
      t.float :electricity_retailer_tarrif

      t.timestamps
    end
  end
end
