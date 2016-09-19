class AddSquadCounterToSprints < ActiveRecord::Migration[5.0]
  def change
    add_column :sprints, :squad_counter, :integer
  end
end
