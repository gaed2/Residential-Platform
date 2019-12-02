class CreateSuppliersPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :suppliers_plans do |t|
      t.string :name
      t.string :contract_duration
      t.integer :plan_type
      t.decimal :price
      t.decimal :price_type
      t.references :electricity_supplier, index: true
      t.boolean :tariff_allow
      t.timestamps
    end
  end
end
