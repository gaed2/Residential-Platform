class RenameTarrifRatesToTariffRates < ActiveRecord::Migration[5.1]
  def change
    rename_table :tarrif_rates, :tariff_rates
    rename_column :tariff_rates, :tarrif_type, :tariff_type
  end
end
