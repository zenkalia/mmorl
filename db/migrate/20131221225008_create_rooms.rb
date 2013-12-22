class CreateRooms < ActiveRecord::Migration
  def change
    create_table :rooms do |t|
    end
    add_column :users, :room_id, :integer #need foreign key
  end
end
