class AddAvatarAndPhoneToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :avatar, :string
    add_column :users, :phone_number, :string
  end
end
