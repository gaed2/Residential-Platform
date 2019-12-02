class AddSupplierElectricityRateToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :supplier_electricity_rate, :float
  end
end
