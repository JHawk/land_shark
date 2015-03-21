class AddEquippedItemToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :equipped_item_id, :integer
    add_column :items, :character_id, :integer
    add_column :items, :damage, :integer
  end
end
