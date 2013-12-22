class CreateFixtures < ActiveRecord::Migration
  def change
    create_table :fixtures do |t|
      t.integer :room_id
      t.boolean :solid
      t.string :char
      t.string :bgc
      t.string :fgc
      t.integer :row
      t.integer :col
    end
  end
end
