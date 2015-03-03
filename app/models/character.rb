require 'faker'

class Character < ActiveRecord::Base
  belongs_to :location
  belongs_to :current_action, class_name: 'Action'
  belongs_to :game

  has_many :actions

  validates_presence_of :name,
    :strength,
    :dexterity,
    :constitution,
    :intelligence,
    :wisdom,
    :charisma,

    :land_speed

  class << self
    def generate_pc!
      generate!
    end

    def generate!(is_pc=true)
      self.create!(generate_characteristics.merge({ is_pc: is_pc }))
    end

    def generate_npc!
      generate!(false)
    end

    def generate_characteristics
      {
        name: Faker::Name.name,

        strength: rand_attribute,
        dexterity: rand_attribute,
        constitution: rand_attribute,
        intelligence: rand_attribute,
        wisdom: rand_attribute,
        charisma: rand_attribute,

        land_speed: rand_attribute
      }
    end

    def rand_attribute
      rand(20) + 1
    end
  end

  def position_a
    [x,y,z]
  end

  def position
    {x:x,y:y,z:z}
  end

  def tick(time)
    if current_action
      current_action.tick time
    end
  end

  def idle?(time)
    current_action.nil? || current_action.finished?(time)
  end
end

