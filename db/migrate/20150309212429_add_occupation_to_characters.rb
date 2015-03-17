class AddOccupationToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :occupation_id, :integer
  end
end
