class MoveCellsToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :fixtures, :text
    drop_table :fixtures
  end
end
