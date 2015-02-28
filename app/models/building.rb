require 'pathfinder/finders/a_star'

class Building < ActiveRecord::Base
  belongs_to :location

  def grid
    Pathfinder::Finders::AStar.new.grid_from_s_map(<<-G)
._________.
.|.......|.
.........|.
.|.......|.
._________.
    G
  end
end

