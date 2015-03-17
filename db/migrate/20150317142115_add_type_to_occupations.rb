class AddTypeToOccupations < ActiveRecord::Migration
  def change
    add_column :occupations, :type, :string
  end
end
