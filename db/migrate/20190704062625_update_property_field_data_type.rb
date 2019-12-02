class UpdatePropertyFieldDataType < ActiveRecord::Migration[5.1]
  def change
    remove_column :properties, :door_name
    add_column :properties, :door_name, :integer
    change_column :properties, :ac_units, :integer
    add_column :properties, :bathrooms, :integer
    add_column :renewable_energy_sources, :unit, :integer
    add_column :electricity_consumption_equipments, :category_type, :integer
  end
end
