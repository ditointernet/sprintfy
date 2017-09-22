class DropReports < ActiveRecord::Migration[5.0]
  def change
    drop_table :reports
  end
end
