require 'faker'
require 'st_inheritable'

class Character < ActiveRecord::Base

  include StInheritable

  belongs_to :current_action, class_name: 'Action'
  belongs_to :equipped_item
  belongs_to :game
  belongs_to :location
  belongs_to :occupation
  belongs_to :target_character, class_name: 'Character'

  has_many :actions, dependent: :destroy
  has_many :items
  has_many :moves, dependent: :destroy

  def mind_attributes
    [
      :perception,
      :intelligence,
      :sanity
    ]
  end

  def body_attributes
    [
      :strength,
      :agility,
      :hit_points
    ]
  end

  def spirit_attributes
    [
      :focus,
      :willpower,
      :essence
    ]
  end

  def other_attributes
    [
      :charisma,
      :land_speed
    ]
  end

  validates_presence_of :type
  validates :gender, inclusion: { in: %w(male female none) }

  validates_presence_of :name,

    :perception,
    :intelligence,
    :sanity,

    :strength,
    :agility,
    :hit_points,

    :focus,
    :willpower,
    :essence,

    :charisma,

    :land_speed

  # speed = tile / second
  # tile = 5 ft

  class << self
    def generate_pc!
      generate!
    end

    def generate!(is_pc=true)
      character = self.create!(generate_characteristics.merge({ is_pc: is_pc }))

      character.occupation = Occupation.random
      Actions::Run.create!(character: character)
      Actions::HunkerDown.create!(character: character)
      Actions::Throw.create!(character: character)
      character
    end

    def generate_npc!
      generate!(false)
    end

    def rand_identity
      raise NotImplementedError, "Must be implemented in subclass"
    end

    def generate_characteristics
      {
        perception: rand_attribute,
        intelligence: rand_attribute,
        sanity: rand_attribute,

        strength: rand_attribute,
        agility: rand_attribute,
        hit_points: rand_attribute,

        focus: rand_attribute,
        willpower: rand_attribute,
        essence: rand_attribute,

        charisma: rand_attribute,

        land_speed: 1
      }.merge(rand_identity)
    end

    def rand_attribute
      rand(20) + 1
    end
  end

  def drop_current_position(_path)
    _path.reject do |pos|
      pos == position_a || (pos.size == 2 && pos == [x,y])
    end
  end

  def can?(action_name, target=nil)
    !!action_by_type(action_name)
  end

  def action_by_type(action_type)
    actions.find do |action|
      action.type.to_s.split('::').second.underscore == action_type.to_s.downcase
    end
  end

  def start_action!(action_name, target_position, time)
    position_h = if target_position.is_a? Array
      {
        x:target_position[0],
        y:target_position[1],
        z:target_position[2]
      }
                 else
                   target_position
                 end

    _path = location.find_path_a(position, position_h)

    if drop_current_position(_path).present?
      update_attributes!({
        path: _path.to_json
      })
      selected_action = action_by_type(action_name)
      if selected_action
        self.update_attributes!(
          current_action_id: selected_action.id
        )

        selected_action.start!(time)
      else
        false
      end
    else
      false
    end
  end

  def path_a
    if path
      parsed = JSON.parse(path) rescue []
      if parsed.is_a? Array
        parsed
      else
        []
      end
    else
      []
    end
  end

  # WOW - hack
  def game!
    _game = game
    if _game
      _game
    else
      location.game
    end
  end

  def take_step!
    _remaining_path = remaining_path_a
    return if _remaining_path.blank?
    _new_position = remaining_path_a.first

    Move.create!({
      character: self,
      game_time: game!.time,
      start_position: position_a.to_json,
      end_position: _new_position.to_json
    })

    update_attributes!(
      path: _remaining_path.to_json,
      x: _new_position[0],
      y: _new_position[1],
      z: _new_position[2]
    )
  end

  def remaining_path_a
    drop_current_position(path_a)
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

