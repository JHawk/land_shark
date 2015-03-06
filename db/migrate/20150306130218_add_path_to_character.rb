class AddPathToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :path, :text
  end
end
