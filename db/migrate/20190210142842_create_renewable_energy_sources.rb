class CreateRenewableEnergySources < ActiveRecord::Migration[5.1]
  def change
    create_table :renewable_energy_sources do |t|
      t.string :name
      t.string :source_type
      t.integer :property_id

      t.timestamps
    end
  end
end
