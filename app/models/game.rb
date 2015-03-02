class Game < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  has_many :locations
  has_many :characters

  after_create :generate_characters!, :generate_locations!

  def move!(character, position)
    current_location.move!(character, position)
  end

  def current_location
    locations.where(is_current: true).first
  end

  def generate_characters!
    self.characters << Character.generate_pc!
  end

  def generate_locations!
    self.locations << Location.generate!
  end

  def current_location!
    locations.first.update_attributes!(is_current: true)
    current_location.spawn(characters)
    current_location.reload
  end

  def json_map
    current_location || current_location!
    current_location.json_map
  end

  def max_x
    current_location.max_x
  end

  def max_y
    current_location.max_y
  end
end

