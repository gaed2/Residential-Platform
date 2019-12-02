class CreateAdvertisements < ActiveRecord::Migration[5.1]
  def change
    create_table :advertisements do |t|
      t.string :company_name
      t.string :image
      t.string :link
      t.string :description
      t.timestamps
    end
  end
end
