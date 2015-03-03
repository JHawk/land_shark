class AddCurrentPlayerToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :current_character_id, :integer
  end
end
