class CreateEquipmentMaintenances < ActiveRecord::Migration[5.1]
  def change
    create_table :equipment_maintenances do |t|
      t.string :name
      t.references :property, index: true, foreign_key: true
      t.date :last_upgraded
      t.integer :frequency
      t.timestamps
    end
  end
end
