class CreateMonsters < ActiveRecord::Migration
  def change
    create_table :monsters do |t|
      t.integer :room_id
      t.integer :row
      t.integer :col
      t.integer :health
      t.string :slug
    end
    add_foreign_key :monsters, :rooms
  end
end
