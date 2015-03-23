class AddIsDeadToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :is_dead, :boolean, :null => false, :default => false
    add_column :characters, :is_insane, :boolean, :null => false, :default => false
  end
end
