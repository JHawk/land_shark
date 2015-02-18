class Location < ActiveRecord::Base
  MAX_X = 100
  MAX_Y = 100
  MAX_Z = 100

  has_many :characters do
    def visible
      where('x IS NOT NULL').
        where('y IS NOT NULL').
        where('z IS NOT NULL')
    end
  end

  def rand_position
    {
      x: rand(MAX_X),
      y: rand(MAX_Y),
      z: rand(MAX_Z)
    }
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
end

