class RenameRoomNumberToDoorName < ActiveRecord::Migration[5.1]
  def change
    rename_column :properties, :room_number, :door_name
    change_column :properties, :door_name, :string
  end
end
