class AddLandSpeedToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :land_speed, :integer
  end
end
