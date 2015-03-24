class AddLocationAndPositionToItems < ActiveRecord::Migration
  def change
    add_column :items, :x, :integer
    add_column :items, :y, :integer
    add_column :items, :z, :integer

    add_column :items, :location_id, :integer
  end
end
