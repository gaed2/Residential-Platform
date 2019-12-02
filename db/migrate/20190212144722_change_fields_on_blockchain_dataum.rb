class ChangeFieldsOnBlockchainDataum < ActiveRecord::Migration[5.1]
  def change
    remove_column :blockchain_data, :property_id, :integer
    remove_index :blockchain_data, :property_id if index_exists?(:blockchain_data, :property_id)
    add_column :blockchain_data, :entity_id, :integer
    add_column :blockchain_data, :entity_type, :string
    add_index :blockchain_data, :entity_id
    add_index :blockchain_data, :entity_type
  end
end
