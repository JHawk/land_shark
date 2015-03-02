class AddIsPcToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :is_pc, :boolean
  end
end
