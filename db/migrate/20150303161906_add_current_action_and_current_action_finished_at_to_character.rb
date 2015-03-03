class AddCurrentActionAndCurrentActionFinishedAtToCharacter < ActiveRecord::Migration
  def change
    add_column :characters, :current_action_id, :integer
    add_index :characters, :current_action_id

    add_column :characters, :action_finished_at, :datetime
  end
end
