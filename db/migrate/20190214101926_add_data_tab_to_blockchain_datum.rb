class AddDataTabToBlockchainDatum < ActiveRecord::Migration[5.1]
  def change
    add_column :blockchain_data, :data_tab, :string
  end
end
