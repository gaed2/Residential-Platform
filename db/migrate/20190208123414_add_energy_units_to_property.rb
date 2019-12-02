class AddEnergyUnitsToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :electricity_consumption_unit, :string
    add_column :properties, :natural_gas_unit, :string
    add_column :properties, :water_unit, :string
    add_column :properties, :avg_room_unit, :string
    add_column :properties, :living_room_unit, :string
    add_column :properties, :dining_room_unit, :string
    add_column :properties, :total_house_unit, :string
    add_column :properties, :floor_cieling_unit, :string
  end
end
