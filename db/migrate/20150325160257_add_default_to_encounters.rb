class AddDefaultToEncounters < ActiveRecord::Migration
  def self.up
    change_column :encounters, :completed, :boolean, default: false
  end

  def self.down
  end
end

