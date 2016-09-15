class CreateStoryPoints < ActiveRecord::Migration[5.0]
  def change
    create_table :story_points do |t|
      t.references :sprint, foreign_key: true
      t.references :user, foreign_key: true
      t.float :expected_value, default: 0
      t.float :value, default: 0

      t.timestamps
    end
  end
end
