class AddSquadToUsers < ActiveRecord::Migration[5.0]
  def change
    add_reference :users, :squad, foreign_key: true
  end
end
