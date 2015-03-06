class AddEventsToCharacters < ActiveRecord::Migration
  def change
    create_table :moves do |t|
      t.belongs_to :character, index: true
      t.string :start_position
      t.string :end_position
      t.datetime :game_time

      t.timestamps
    end
  end
end

