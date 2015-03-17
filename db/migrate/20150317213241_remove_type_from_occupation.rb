class RemoveTypeFromOccupation < ActiveRecord::Migration
  def change
    remove_column :occupations, :type
  end
end
