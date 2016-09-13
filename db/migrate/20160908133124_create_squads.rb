class CreateSquads < ActiveRecord::Migration[5.0]
  def change
    create_table :squads do |t|
      t.string :name

      t.timestamps
    end
  end
end
