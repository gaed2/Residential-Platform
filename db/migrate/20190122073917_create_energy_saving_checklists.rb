class CreateEnergySavingChecklists < ActiveRecord::Migration[5.1]
  def change
    create_table :energy_saving_checklists do |t|
      t.string :heading
      t.string :question
      t.timestamps
    end
  end
end
