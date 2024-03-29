require 'faker'
require 'st_inheritable'
require 'positionable'

class Character < ActiveRecord::Base

  include StInheritable
  include Positionable

  validate :equipped_item_in_inventory

  belongs_to :current_action, class_name: 'Action'
  belongs_to :equipped_item, class_name: 'Item'
  belongs_to :target_item, class_name: 'Item'
  belongs_to :target_character, class_name: 'Character'
  belongs_to :game
  belongs_to :location
  belongs_to :encounter
  belongs_to :occupation

  has_many :relationships
  has_many :acquaintances, through: :relationships do
    def enemies
      includes(:relationships).where('relationships.rating < 0')
    end

    def allies
      includes(:relationships).where('relationships.rating > 0')
    end
  end
  delegate :enemies, to: :acquaintances
  delegate :allies, to: :acquaintances

  has_many :items

  has_many :moves, dependent: :destroy
  has_many :actions, dependent: :destroy

  def ready_combat_actions
    ready_actions.select(&:combat?)
  end

  def ready_noncombat_actions
    ready_actions.select(&:noncombat?)
  end

  def combat_actions
    actions.select(&:combat?)
  end

  def ready_actions
    actions.select(&:ready?)
  end

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
      Actions::PickUp.create!(character: character)
      Actions::Equip.create!(character: character)

      character.generate_equipment!

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

  def generate_equipment!
    5.times do |i|
      items << Item.create!(name: "knife #{rand 100000}", damage: (rand 5) + 1)
    end
    equip!
  end

  def equip!(item=nil)
    item ||= items.sample
    update_attributes!(equipped_item: item)
  end

  def equipped_item_in_inventory?
    !equipped_item || items.include?(equipped_item)
  end

  def equipped_item_in_inventory
    unless equipped_item_in_inventory?
      errors.add(:character, "Equipped item not in inventory")
    end
  end

  def drop_current_position(_path)
    _path.reject do |pos|
      pos == position_a || (pos.size == 2 && pos == [x,y])
    end
  end

  class Attack
    attr_reader :attacker,
      :target,
      :item,
      :accuracy,
      :damage,
      :power,
      :crit

    def initialize(attacker, target)
      @attacker = attacker
      @target = target

      @damage = [0, attacker.strength - 10].max
      @accuracy = [0, attacker.agility - 10].max
    end

    def with(item)
      @item = item
      @damage = @damage + item.damage
      puts "DAMAGE #{@damage}"
      self
    end

    def resolve!
      target.update_attributes!(hit_points: target.hit_points - @damage)
      target.hate!(attacker)
      if target.enemies.include?(attacker)
        target.fight!
      end

      if target.hit_points < 1
        target.dies!
      end
    end
  end

  def fighting?
    current_action.present? && combat_actions.include?(current_action)
  end

  def fight!
    if !fighting? && combat_actions.present?
      update_attributes!(current_action: nil)
    end
  end

  def hate!(other)
    rel = relationships.where(acquaintance: other).first_or_create
    new_rating = rel.rating.present? ? rel.rating - 10 : -10
    rel.update_attributes!(rating: new_rating)
  end

  def dies!
    update_attributes!({
      is_dead: true
    })
    encounter.check_complete! if encounter
    self
  end

  def ranged_attack(target)
    Attack.new(self, target)
  end

  def can?(action_name, target=nil)
    action = action_by_type action_name
    !!(action && action.ready?)
  end

  def action_by_type(action_type)
    actions.find do |action|
      action.type.to_s.split('::').second.underscore == action_type.to_s.downcase
    end
  end

  def needs_target?
    !valid_target?
  end

  def valid_target?
    target_character.present? && target_character.alive?
  end

  def decide_target
    if needs_target?
      update_attributes!(target_character: acquaintances.enemies.first)
    end
  end

  def decide_action
    selected_action = if valid_target? && ready_combat_actions.present?
      ready_combat_actions.sample
    elsif ready_noncombat_actions.present?
      ready_noncombat_actions.sample
    end

    update_attributes!(current_action: selected_action)
    selected_action
  end

  def decide_path
    destination = if valid_target?
      target_character.position
    else
      location.rand_open_position
    end

    _path = location.find_path_a(position, destination)

    if drop_current_position(_path).present?
      update_attributes!({
        path: _path.to_json
      })
    end
    destination
  end

  def start_current_action!(time)
    current_action.start!(time)
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

  def tick(time)
    if current_action && alive?
      current_action.tick time
    end
  end

  def alive?
    !dead?
  end

  def dead?
    !!is_dead
  end

  def idle?(time)
    current_action.nil? || current_action.finished? || current_action.times_up?(time)
  end
end

