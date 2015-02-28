require 'pathfinder/finders/a_star'

class Location < ActiveRecord::Base
  include Pathfinder::Finders

  class << self
    def generate!
      self.create!.tap do |location|
        postition = location.rand_position

        x = postition[:x]
        y = postition[:y]

        location.buildings << Building.create!(bottom_left_x:x, bottom_left_y: y)
      end
    end
  end

  has_many :buildings do
  end

  has_many :characters do
    def visible
      where('x IS NOT NULL').
        where('y IS NOT NULL').
        where('z IS NOT NULL')
    end
  end

  def rand_position
    {
      x: rand(max_x),
      y: rand(max_y),
      z: rand(max_z)
    }
  end

  def grid
    {max_x: max_x, max_y: max_y}
  end

  def move!(character, position)
    if characters.include?(character)

      position_h = {
        x:position[0],
        y:position[1],
        z:position[2]
      }

      path = AStar.new.find_path(character.position, position_h, grid)

      if path.present?
        distance_traveled = path.length - 1
        if 0 < distance_traveled && distance_traveled <= character.land_speed
          character.update_attributes!({
            x: position[0],
            y: position[1],
            z: position[2]
          })
        else
          false
        end
      else
        false
      end
    else
      false
    end
  end

  def spawn(characters)
    characters.each do |character|
      character.update_attributes!(
        rand_position.merge(
          {
            location_id: id
          }
        )
      )
    end
  end

  def visible_sprites
    characters.visible
  end

  def json_map

    sprites_map = visible_sprites.inject({}) do |acc, sprite|
      acc[sprite.position_a] = sprite
      acc
    end

    buildings.inject(sprites_map) do |acc, building|
      building_positions = building.grid.reject {|k,v| k.is_a? Symbol}
      sprites_map.merge(building_positions)
    end
  end
end

