class CreatePropertySubCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :property_sub_categories do |t|
      t.string :name
      t.integer :status, default: 0
      t.references :property_category, index: true, foreign_key: true
      t.timestamps
    end
  end
end
