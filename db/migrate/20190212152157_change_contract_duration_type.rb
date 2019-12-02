class ChangeContractDurationType < ActiveRecord::Migration[5.1]
  def change
    remove_column :suppliers_plans, :contract_duration
    add_column :suppliers_plans, :contract_duration, :integer
  end
end
