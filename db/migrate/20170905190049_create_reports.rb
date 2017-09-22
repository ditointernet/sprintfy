class CreateReports < ActiveRecord::Migration[5.0]
  def change
    create_table :reports do |t|
      t.references :sprints, foreign_key: true
      t.references :squads, foreign_key: true
      t.references :users, foreign_key: true
    end
  end
end
