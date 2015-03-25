class AddEncounterToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :encounter_id, :integer
  end
end

