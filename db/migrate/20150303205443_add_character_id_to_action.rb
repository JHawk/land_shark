class AddCharacterIdToAction < ActiveRecord::Migration
  def change
    add_column :actions, :ticks, :integer, default: 0, null: false
    add_column :actions, :last_ticked_at, :datetime

    add_column :actions, :character_id, :integer
    add_index :actions, :character_id
  end
end
