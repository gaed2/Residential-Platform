class AddNewFieldsToElectricityConsumptionEquipment < ActiveRecord::Migration[5.1]
  def change
    remove_column :electricity_consumption_equipments, :year_installed
    add_column :electricity_consumption_equipments, :year_installed, :integer
    add_column :electricity_consumption_equipments, :rating, :integer
    add_column :electricity_consumption_equipments, :rated_kw, :integer
    add_column :electricity_consumption_equipments, :quantity, :integer
  end
end
