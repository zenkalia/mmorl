class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.integer :room_id
      t.integer :user_id
      t.integer :row
      t.integer :col
      t.string :slug
    end
    add_foreign_key :items, :rooms
    add_foreign_key :items, :users
  end
end
