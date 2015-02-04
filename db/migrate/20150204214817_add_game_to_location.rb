class AddGameToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :game_id, :integer
    add_index :locations, :game_id
  end
end
