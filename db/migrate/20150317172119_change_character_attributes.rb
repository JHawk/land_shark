class ChangeCharacterAttributes < ActiveRecord::Migration
  def change
    rename_column :characters, :dexterity, :agility
    rename_column :characters, :wisdom, :perception

    add_column :characters, :willpower, :integer
    add_column :characters, :focus, :integer

    rename_column :characters, :constitution, :hit_points
    add_column :characters, :essence, :integer
    add_column :characters, :sanity, :integer
  end
end
