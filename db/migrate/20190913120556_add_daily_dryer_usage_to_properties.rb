class AddDailyDryerUsageToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :daily_dryer_usage, :integer
  end
end
