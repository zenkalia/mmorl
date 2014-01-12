class AddTargetToMonsters < ActiveRecord::Migration
  def change
    add_column :monsters, :target_id, :integer
  end
end
