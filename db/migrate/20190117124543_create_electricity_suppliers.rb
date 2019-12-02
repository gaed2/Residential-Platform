class CreateElectricitySuppliers < ActiveRecord::Migration[5.1]
  def change
    create_table :electricity_suppliers do |t|
      t.string :name
      t.string :logo
      t.string :website_link
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
