class AddDurationOfStayMonthToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :duration_of_stay_month, :integer
    rename_column :properties, :duration_of_stay, :duration_of_stay_year
    change_column :properties, :duration_of_stay_year, :integer
  end
end
