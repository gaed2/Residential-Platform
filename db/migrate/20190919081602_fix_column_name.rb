class FixColumnName < ActiveRecord::Migration[5.1]
  def change
    rename_column :solar_pv_systems, :current_tarrif, :current_tariff 
 	  rename_column :solar_pv_systems, :electricity_retailer_tarrif, :electricity_retailer_tariff
  end
end
