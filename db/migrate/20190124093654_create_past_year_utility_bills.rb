class CreatePastYearUtilityBills < ActiveRecord::Migration[5.1]
  def change
    create_table :past_year_utility_bills do |t|
      t.string :category
      t.string :file
      t.references :property
      t.timestamps
    end
  end
end
