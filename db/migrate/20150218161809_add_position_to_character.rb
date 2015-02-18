class AddPositionToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :x, :integer
    add_column :characters, :y, :integer
    add_column :characters, :z, :integer
  end
end
