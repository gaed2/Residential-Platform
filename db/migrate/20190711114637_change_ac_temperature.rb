class ChangeAcTemperature < ActiveRecord::Migration[5.1]
  def change
    change_column :properties, :ac_temperature, :integer
  end
end
