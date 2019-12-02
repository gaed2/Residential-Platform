class CreateEnergyData < ActiveRecord::Migration[5.1]
  def change
    create_table :energy_data do |t|
      t.date :date
      t.decimal :cost
      t.decimal :energy_consumption
      t.references :property, index: true, foreign_key: true
      t.timestamps
    end
  end
end
