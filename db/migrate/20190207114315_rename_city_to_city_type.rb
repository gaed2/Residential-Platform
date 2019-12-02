class RenameCityToCityType < ActiveRecord::Migration[5.1]
  def change
    remove_column :properties, :state
    remove_column :properties, :city
    add_column :properties, :city_id, :integer
  end
end
