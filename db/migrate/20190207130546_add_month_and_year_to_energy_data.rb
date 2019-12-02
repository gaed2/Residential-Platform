class AddMonthAndYearToEnergyData < ActiveRecord::Migration[5.1]
  def change
    add_column :energy_data, :month, :integer
    add_column :energy_data, :year, :integer
  end
end
