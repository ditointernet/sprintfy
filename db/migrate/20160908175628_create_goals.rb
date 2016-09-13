class CreateGoals < ActiveRecord::Migration[5.0]
  def change
    create_table :goals do |t|
      t.text :description
      t.boolean :completed, default: false

      t.timestamps
    end
  end
end
