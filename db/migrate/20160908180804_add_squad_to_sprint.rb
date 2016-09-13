class AddSquadToSprint < ActiveRecord::Migration[5.0]
  def change
    add_reference :sprints, :squad, foreign_key: true
  end
end
