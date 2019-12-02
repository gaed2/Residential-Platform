class CreatePropertyChecklists < ActiveRecord::Migration[5.1]
  def change
    create_table :property_checklists do |t|
      t.references :property, index: true, foreign_key: true
      t.references :energy_saving_checklist, index: true, foreign_key: true
      t.string :answer
      t.timestamps
    end
  end
end
