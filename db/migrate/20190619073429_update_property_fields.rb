class UpdatePropertyFields < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :floor_number, :integer
    add_column :properties, :room_number, :integer
    add_column :properties, :full_time_occupancy, :boolean
    add_column :properties, :duration_of_stay, :float
    add_column :properties, :has_ac, :boolean
    add_column :properties, :ac_units, :float
    add_column :properties, :ac_temperature, :float
    add_column :properties, :ac_start_time, :time
    add_column :properties, :ac_stop_time, :time
    add_column :properties, :roof_length, :float
    add_column :properties, :roof_length_unit, :string
    add_column :properties, :roof_breadth, :float
    add_column :properties, :roof_breadth_unit, :string
  end
end
