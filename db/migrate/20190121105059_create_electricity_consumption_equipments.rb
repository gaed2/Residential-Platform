class CreateElectricityConsumptionEquipments < ActiveRecord::Migration[5.1]
  def change
    create_table :electricity_consumption_equipments do |t|
      t.string :name
      t.string :equipment_type
      t.date :year_installed
      t.time :start_active_time
      t.time :end_active_time
      t.decimal :cost
      t.decimal :electricity_consumption
      t.string :description
      t.references :property, index: true, foreign_key: true
      t.string :location
      t.integer :status
      t.timestamps
    end
  end
end
