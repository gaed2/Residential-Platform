class AddOtherSuppliersToProperty < ActiveRecord::Migration[5.1]
  def change
    add_column :properties, :different_supplier_from, :date
    add_column :properties, :different_supplier_to, :date
  end
end
