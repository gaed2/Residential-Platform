class CreatePeakAndOffPeakPlans < ActiveRecord::Migration[5.1]
  def change
    create_table :peak_and_off_peak_plans do |t|
      t.time :peak_start
      t.time :peak_end
      t.time :peak_off_start
      t.time :peak_off_end
      t.integer :peak_price_type
      t.decimal :peak_price
      t.integer :peak_off_price_type
      t.decimal :peak_off_price
      t.boolean :tariff_allow
      t.references :electricity_supplier, index: true
      t.timestamps
    end
  end
end
