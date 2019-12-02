class CreateBlockchainData < ActiveRecord::Migration[5.1]
  def change
    create_table :blockchain_data do |t|
      t.uuid :uuid, comment: 'unique uuid'
      t.string :data_hash, comment: 'encrypted hash SHA 256'
      t.string :data_type, comment: 'user_data, image, pdf'
      t.string :data_url, comment: 'url of image / pdf or json file'
      t.integer :status, comment: 'inprogress, success , failed, timeout'
      t.datetime :deleted_at, comment: 'true if soft deleted'
      t.integer :property_id, comment: 'foriegn key for property'
      # entity_id
      # entity_type
      # Remove property_id

      t.timestamps
    end
    add_index :blockchain_data, :deleted_at
    add_index :blockchain_data, :property_id
  end
end



