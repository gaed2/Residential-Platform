class AddSupplierPlanIdToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :suppliers_plan_id, :integer
  end
end
