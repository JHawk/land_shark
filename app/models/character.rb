require 'faker'

class Character < ActiveRecord::Base
  belongs_to :location
  belongs_to :game

  attr_accessor :name,
    :strength,
    :dexterity,
    :constitution,
    :intelligence,
    :wisdom,
    :charisma

  validates_presence_of :name,
    :strength,
    :dexterity,
    :constitution,
    :intelligence,
    :wisdom,
    :charisma

  def rand_attribute
    rand(20) + 1
  end

  def generate_characteristics
    self.name = Faker::Name.name

    self.strength = rand_attribute
    self.dexterity = rand_attribute
    self.constitution = rand_attribute
    self.intelligence = rand_attribute
    self.wisdom = rand_attribute
    self.charisma = rand_attribute

    self
  end
end

