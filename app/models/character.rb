require 'faker'

class Character < ActiveRecord::Base
  belongs_to :location
  belongs_to :game

  validates_presence_of :name,
    :strength,
    :dexterity,
    :constitution,
    :intelligence,
    :wisdom,
    :charisma

  class << self
    def generate!
      self.create!(generate_characteristics)
    end

    def generate_characteristics
      {
        name: Faker::Name.name,

        strength: rand_attribute,
        dexterity: rand_attribute,
        constitution: rand_attribute,
        intelligence: rand_attribute,
        wisdom: rand_attribute,
        charisma: rand_attribute
      }
    end

    def rand_attribute
      rand(20) + 1
    end
  end

  def position
    [x,y,z]
  end
end

