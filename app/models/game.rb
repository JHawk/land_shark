class Game < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  has_many :locations
  has_many :characters

  after_create :generate_characters!, :generate_locations!

  def generate_characters!
    character = Character.new.generate_characteristics
    character.save!
    self.characters << character
  end

  def generate_locations!
    location = Location.new
    location.save!
    self.locations << location
  end
end

