class AddPositionToUsers < ActiveRecord::Migration
  def change
    add_column :users, :col, :integer, default: 1
    add_column :users, :row, :integer, default: 1
  end
end
