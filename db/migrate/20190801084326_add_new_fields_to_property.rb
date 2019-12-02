class AddNewFieldsToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :people_at_home, :integer
    add_column :properties, :ac_in_use, :integer
    add_column :properties, :solar_power_consumption, :float
    add_column :properties, :solar_power_consumption_unit, :string
    add_column :properties, :is_supplier_changed, :boolean
    add_column :properties, :has_dryer, :boolean
  end
end
