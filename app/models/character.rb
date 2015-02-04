class Character < ActiveRecord::Base
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
end

