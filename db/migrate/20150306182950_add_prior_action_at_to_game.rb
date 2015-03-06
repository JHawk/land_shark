class AddPriorActionAtToGame < ActiveRecord::Migration
  def change
    add_column :games, :prior_action_at, :datetime
  end
end
