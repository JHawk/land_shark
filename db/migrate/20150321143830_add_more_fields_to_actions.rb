class AddMoreFieldsToActions < ActiveRecord::Migration
  def change
    add_column :characters, :target_character_id, :integer
  end
end
