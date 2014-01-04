class AddHealthToUsers < ActiveRecord::Migration
  def change
    add_column :users, :health, :integer, default: 14
    add_column :users, :max_health, :integer, default: 14
  end
end
