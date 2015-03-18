class AddFormToCharacters < ActiveRecord::Migration
  def change
    add_column :characters, :type, :string
    add_column :characters, :gender, :string, :null => false, :default => 'none'
  end
end

