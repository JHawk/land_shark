class AddTimeToGame < ActiveRecord::Migration
  def change
    add_column :games, :time, :datetime
  end
end

