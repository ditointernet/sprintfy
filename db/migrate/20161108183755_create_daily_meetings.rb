class CreateDailyMeetings < ActiveRecord::Migration[5.0]
  def change
    create_table :daily_meetings do |t|
      t.string :reason
      t.date :date
      t.boolean :done
      t.boolean :skip
      t.references :squad, foreign_key: true
      t.references :sprint, foreign_key: true

      t.timestamps
    end
  end
end
