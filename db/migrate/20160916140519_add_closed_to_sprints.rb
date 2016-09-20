class AddClosedToSprints < ActiveRecord::Migration[5.0]
  def change
    add_column :sprints, :closed, :boolean, default: false
  end
end
