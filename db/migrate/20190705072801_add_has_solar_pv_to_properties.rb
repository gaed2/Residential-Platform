class AddHasSolarPvToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :has_solar_pv, :boolean
  end
end
