class AddGameToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :game_id, :integer
    add_index :characters, :game_id
  end
end
