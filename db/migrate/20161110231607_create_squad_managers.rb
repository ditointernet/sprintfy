class CreateSquadManagers < ActiveRecord::Migration[5.0]
  def change
    create_table :squad_managers do |t|
      t.references :user, foreign_key: true
      t.references :squad, foreign_key: true

      t.timestamps
    end
  end
end
