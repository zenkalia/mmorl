class AddLetterToItems < ActiveRecord::Migration
  def change
    add_column :items, :letter, :string
  end
end
