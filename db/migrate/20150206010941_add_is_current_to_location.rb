class AddIsCurrentToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :is_current, :boolean
  end
end
