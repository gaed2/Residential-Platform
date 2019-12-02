class CreateProperties < ActiveRecord::Migration[5.1]
  def change
    create_table :properties do |t|
      t.string :owner_name
      t.string :owner_email
      t.references :user, index: true, foreign_key: true
      t.references :property_sub_category, index: true, foreign_key: true
      t.string :contact_number
      t.string :zip
      t.string :locality
      t.string :state
      t.string :city
      t.string :country
      t.integer :adults
      t.integer :children
      t.integer :senior_citizens
      t.integer :bedrooms
      t.integer :floors
      t.decimal :avg_room_size
      t.decimal :living_room_size
      t.decimal :dining_room_size
      t.decimal :total_house_size
      t.string :floor_cieling_height
      t.time :start_time
      t.time :end_time
      t.decimal :electricity_consumption
      t.decimal :water_consumption
      t.decimal :natural_gas_consumption
      t.decimal :other_consumptions
      t.references :current_electricity_supplier, index: true, foreign_key: { to_table: :electricity_suppliers }
      t.date :from
      t.date :to
      t.string :electrical_distribution_schematic_diagram
      t.string :equipment_list_and_specification
      t.integer :status, default: 0
      t.timestamps
    end
  end
end

