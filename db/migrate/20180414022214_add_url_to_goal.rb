class AddUrlToGoal < ActiveRecord::Migration[5.0]
  def change
    add_column :goals, :url, :string
  end
end
