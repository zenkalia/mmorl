class AddRoomUserForeignKey < ActiveRecord::Migration
  def change
    add_foreign_key :users, :rooms
  end
end
