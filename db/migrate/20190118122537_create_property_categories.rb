class CreatePropertyCategories < ActiveRecord::Migration[5.1]
  def change
    create_table :property_categories do |t|
      t.string :name
      t.string :icon
      t.integer :status, default: 0
      t.timestamps
    end
  end
end
