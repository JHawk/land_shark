class RemoveFinishedAtFromCharacters < ActiveRecord::Migration
  def change
    remove_column :characters, :action_finished_at

    add_column :actions, :finished_at, :datetime
    add_column :actions, :started_at, :datetime
  end
end
