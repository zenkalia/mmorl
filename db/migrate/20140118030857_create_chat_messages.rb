class CreateChatMessages < ActiveRecord::Migration
  def change
    create_table :chat_messages do |t|
      t.integer :room_id
      t.integer :user_id
      t.string :body
      t.string :public_body
      t.timestamps
    end
  end
end
