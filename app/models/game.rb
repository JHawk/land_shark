class Game < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user

  has_many :locations

  has_many :encounters, through: :locations do
  end

  has_many :characters do
    def available
      where('location_id IS NULL')
    end

    def pcs
      where(is_pc: true)
    end

    def npcs
      where(is_pc: false)
    end
  end

  def setup!
    set_time!
    generate_characters!
    generate_locations!
    generate_encounters!
  end

  def move!(character, position, action_name)
    result = current_location.move!(character, position, action_name)

    if result && result[:time]
      update_attributes!(
        time: result[:time],
        prior_action_at: time
      )
    end
  end

  def recent_moves
    current_location.moves.since(prior_action_at)
  end

  def current_location
    locations.where(is_current: true).first
  end

  HELLRAISER_RELEASE_DATE = 'September 18, 1987'
  def set_time!
    update_attributes!(time: Time.parse(HELLRAISER_RELEASE_DATE))
  end

  def generate_characters!
    4.times do
      self.characters << Characters::Human.generate_pc!
    end
  end

  def police_station
    locations.where(type: Locations::PoliceStation).first
  end

  def hospital
    locations.where(type: Locations::Hospital).first
  end

  def generate_locations!
    Location.st_types.each do |_type|
      _type.generate!(self)
    end
  end

  def current_location!
    locations.sample.update_attributes!(is_current: true)
    current_location.spawn_group(characters)
    current_location.reload
  end

  def generate_encounters!
    l = locations.sample
    Encounter.generate_at! l if l
  end

  def wait_until_next!
    if encounters.incomplete.empty?
      generate_encounters!
      new_time = encounters.incomplete.order(:starts_at).first.starts_at
      update_attributes!(time: new_time)
    end
  end

  def json_map
    if current_location
      current_location.json_map
    else
      {}
    end
  end

  # move to location json
  def max_x
    current_location.max_x
  end

  # move to location json
  def max_y
    current_location.max_y
  end
end

