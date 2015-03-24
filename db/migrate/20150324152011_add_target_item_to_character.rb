class AddTargetItemToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :target_item_id, :integer
  end
end
