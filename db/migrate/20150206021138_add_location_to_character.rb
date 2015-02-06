class AddLocationToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :location_id, :integer
  end
end
