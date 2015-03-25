class AddStartsAtEndsAtToEncounters < ActiveRecord::Migration
  def change
    add_column :encounters, :starts_at, :datetime
    add_column :encounters, :ends_at, :datetime
    add_column :encounters, :failed, :boolean, default: false
  end
end
