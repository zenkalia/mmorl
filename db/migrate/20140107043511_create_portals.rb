class CreatePortals < ActiveRecord::Migration
  def change
    create_table :portals do |t|
      t.integer :entry_room_id
      t.integer :entry_row
      t.integer :entry_col
      t.string  :char
      t.integer :exit_room_id
      t.integer :exit_row
      t.integer :exit_col
    end
  end
end
