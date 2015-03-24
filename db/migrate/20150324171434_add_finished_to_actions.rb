class AddFinishedToActions < ActiveRecord::Migration
  def change
    add_column :actions, :finished, :boolean
  end
end
