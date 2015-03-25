require 'st_inheritable'
require 'errors/wrong_character_moved_error'
require 'pathfinder/finders/a_star'

class Location < ActiveRecord::Base

  include StInheritable
  include Pathfinder::Finders

  has_one :current_character, class_name: 'Character'
  belongs_to :game
  has_many :encounters

  validates_presence_of :type

  before_save :ensure_current_pc, :spawn_pcs_together

  class << self
    def generate!(game=nil)
      self.create!({game: game}).tap do |location|
        postition = location.rand_open_position

        x = postition[:x]
        y = postition[:y]

        npc = Characters::Human.generate_npc!
        location.characters << npc
        location.spawn(npc)

        location.buildings << Building.create!(bottom_left_x:x, bottom_left_y: y)
      end
    end

  end

  def generate_npc_group!(count)
    group = 1.upto(count).map do |i|
      Characters::Human.generate_npc!
    end
    spawn_group group
    group
  end

  has_many :moves, through: :characters do
    def since(time)
      self #where('game_time > ?', time)
    end
  end

  has_many :buildings do
  end

  has_many :characters do
    def positioned
      where('x IS NOT NULL').
        where('y IS NOT NULL').
        where('z IS NOT NULL')
    end

    def visible
      positioned
    end

    def pcs
      positioned.where(is_pc: true)
    end

    def npcs
      positioned.where(is_pc: false)
    end

    def by_initiative
      order('agility DESC')
    end
  end

  has_many :items do
    def positioned
      where('x IS NOT NULL').
        where('y IS NOT NULL').
        where('z IS NOT NULL')
    end

    def visible
      positioned.where('character_id IS NULL')
    end
  end

  def closed_positions
    _json_map = json_map
    _json_map.clone.each do |k, unwalkable|
      if k.is_a?(Array) && k.size > 2
        _json_map[k.take(2)] = unwalkable
      end
    end
    _json_map
  end

  def valid_position?(position)
    position[:x] >= 0 &&
    position[:y] >= 0 &&
    position[:x] < max_x &&
    position[:y] < max_y
  end

  def positions_near(position)
    (position[:x] - 2).upto(position[:x] + 2).map do |x|
      (position[:y] - 2).upto(position[:y] + 2).map do |y|
        unless (x == position[:x] && y == position[:y])
          p = {x:x, y:y, z:position[:z]}
          if valid_position?(p)
            p
          end
        end
      end
    end.flatten.compact.shuffle
  end

  def open_position_near(position)
    _positions_near = positions_near(position)
    open_position { _positions_near.pop }
  end

  def rand_open_position
    open_position { rand_position }
  end

  def open_position
    _closed_positions = closed_positions

    attempts = max_x + max_y + max_z
    attempts.times do
      position = yield
      if position
        unless _closed_positions[[position[:x],position[:y]]]
          return position
        end
      end
    end

    puts "Could not find an open position after #{attempts} attempts!"
    nil
  end

  def rand_position
    if max_x > 0 && max_y > 0 && max_z > 0
      {
        x: rand(max_x),
        y: rand(max_y),
        z: rand(max_z)
      }
    end
  end

  def grid
    building_positions({
      max_x: max_x,
      max_y: max_y
    })
  end

  TICK_TIME = 1 # seconds for now

  def next_current_character(time=nil, tick_time=TICK_TIME)
    return unless characters.pcs.present?

    time ||= game.time
    time_s = time.to_i

    _characters = characters.by_initiative
    _count = 0

    while true do
      utc_t = Time.at(time_s).utc
      _count += 1

      raise "Out of Control" if _count > 1000

      _characters.each do |c|
        c.tick(utc_t)

        if c.idle?(utc_t)
          if c.is_pc
            characters.includes(:current_action).each do |c|
              c.current_action.try(:ensure_finalized!)
            end

            return {
              pc: c,
              time: utc_t
            }
          else
            c.start_action!(:run, rand_open_position, time)
          end
        end
      end

      time_s += tick_time
    end
    nil
  end

  def find_path(_start, _end)
    AStar.new.find_path(_start, _end, grid)
  end

  def find_path_a(_start, _end)
    find_path(_start, _end).map do |pos|
      [pos[:x], pos[:y], (pos[:z] || 1)]
    end
  end

  def move!(character, position, action_name)
    time ||= game.time

    if character != current_character
      raise Errors::WrongCharacterMovedError.new(self, character)
    end

    if characters.pcs.include?(character)
      character.start_action!(action_name.to_sym, position, time)

      # TODO - fix when prior action at and timestamps are millis
      characters.each do |c|
        c.moves.delete_all
      end

      nextone = next_current_character

      if nextone[:pc]
        self.update_attributes!(current_character_id: nextone[:pc].id)
      end
      nextone
    else
      false
    end
  end

  def evacuate!
    characters.each do |c|
      c.update_attributes!(
        location_id: nil,
        current_action_id: nil,
        path: nil
      )
    end
  end

  def spawn_together(characters)
    if characters.present?
      characters = characters.shuffle
      character = characters.shift
      spawn(character)

      characters.each do |c|
        position = character.reload.position
        spawn_near(c,position)
        character = c
      end
    end
  end

  def spawn(character)
    spawn_at(character, rand_open_position)
  end

  def spawn_near(character, position)
    spawn_at(character, open_position_near(position))
  end

  def spawn_at(character,position)
    character.update_attributes!(
      position.merge(
        {
          location_id: id
        }
      )
    )
  end

  def spawn_group(characters)
    characters.each do |character|
      spawn(character)
    end
  end

  def building_positions(init={})
    buildings.inject(init) do |acc, building|
      building_positions = building.grid.reject {|k,v| k.is_a? Symbol}
      acc.merge(building_positions)
    end
  end

  def current_character!
    if current_character_id.present?
      Character.find current_character_id
    else
      c = characters.pcs.sample
      if c.present?
        self.update_attributes!(current_character_id: c.id)
      end
      c
    end
  end

  def visible_sprites
    characters.visible.concat(items.visible)
  end

  def json_map
    sprites_map = visible_sprites.inject({}) do |acc, sprite|
      acc[sprite.position_a] ||= []
      acc[sprite.position_a] << sprite
      acc
    end

    cc = current_character!

    cc_response = cc.present? ?
      {
        current_character: cc,
        current_actions: cc.actions.map {|a| {action: a,name: a.display_name}}
      } : {}

    building_positions(sprites_map).merge(cc_response)
  end

  private

  def ensure_current_pc
    current_character!
  end

  def spawn_pcs_together
    spawn_together(characters.pcs)
  end
end

