class Game < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  has_many :locations
  has_many :characters

  after_create :generate_characters!, :generate_locations!

  def current_location
    locations.where(is_current: true).first
  end

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

  def current_location!
    locations.first.update_attributes!(is_current: true)
    cl = current_location
    characters.each do |character|
      character.update_attributes!(location_id: cl.id)
    end
    cl.reload
  end

  def json_map
    current_location || current_location!
  end
end

