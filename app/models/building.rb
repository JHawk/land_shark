require 'pathfinder/finders/a_star'

class Building < ActiveRecord::Base
  belongs_to :location

  def grid
    if positioned?
      x, y = bottom_left_x, bottom_left_y

      grid_rep.inject({}) do |acc, kv|
        if kv.first.is_a? Array
          new_x = kv.first.first + x
          new_y = kv.first.second + y
          acc[[new_x, new_y]] = kv.second
        else
          acc[kv.first] = kv.second
        end
        acc
      end
    else
      grid_rep
    end
  end

  def positioned?
    bottom_left_x && bottom_left_y
  end

  def grid_rep
    Pathfinder::Finders::AStar.new.grid_from_s_map(<<-G)
._________.
.|.......|.
.........|.
.|.......|.
._________.
    G
  end
end

