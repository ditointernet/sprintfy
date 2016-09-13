class CreateSprintsUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :sprints_users do |t|
      t.references :user, foreign_key: true
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
