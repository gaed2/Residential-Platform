class AddUpgradedMonthYearToEquipmentMaintenance < ActiveRecord::Migration[5.1]
  def change
    remove_column :equipment_maintenances, :last_upgraded
    add_column :equipment_maintenances, :last_upgraded_month, :integer
    add_column :equipment_maintenances, :last_upgraded_year, :integer
  end
end
