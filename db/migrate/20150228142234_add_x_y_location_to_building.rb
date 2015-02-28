class AddXYLocationToBuilding < ActiveRecord::Migration
  def change
    add_column :buildings, :bottom_left_x, :integer
    add_column :buildings, :bottom_left_y, :integer
  end
end
