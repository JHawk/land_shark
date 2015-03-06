class Move < ActiveRecord::Base
  belongs_to :character
  validates_presence_of :character, :game_time, :start_position, :end_position
end

