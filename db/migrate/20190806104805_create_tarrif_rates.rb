class CreateTarrifRates < ActiveRecord::Migration[5.1]
  def change
    create_table :tarrif_rates do |t|
      t.string :name
      t.float :rate
      t.float :gst
      t.float :rate2
      t.date :valid_from
      t.date :valid_to
      t.string :cost_per_unit
      t.float :water_consumption_limit
      t.integer :tarrif_type

      t.timestamps
    end
  end
end
