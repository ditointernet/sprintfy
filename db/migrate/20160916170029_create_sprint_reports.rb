class CreateSprintReports < ActiveRecord::Migration[5.0]
  def change
    create_table :sprint_reports do |t|
      t.references :sprint, foreign_key: true
      t.string :name
      t.text :text

      t.timestamps
    end
  end
end
