class CreateMemories < ActiveRecord::Migration
  def change
    create_table :memories do |t|
      t.integer :user_id
      t.integer :room_id
      t.text    :fixtures
    end
    add_foreign_key :memories, :users
  end
end
