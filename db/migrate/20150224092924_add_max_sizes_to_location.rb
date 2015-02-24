class AddMaxSizesToLocation < ActiveRecord::Migration
  def change
    add_column :locations, :max_x, :integer, default: 100, null: false
    add_column :locations, :max_y, :integer, default: 100, null: false
    add_column :locations, :max_z, :integer, default: 100, null: false
  end
end
