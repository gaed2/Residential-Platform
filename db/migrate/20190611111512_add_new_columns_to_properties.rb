class AddNewColumnsToProperties < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :draft, :boolean, default: false
    add_column :properties, :current_step, :integer
  end
end
