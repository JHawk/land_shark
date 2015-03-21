require 'st_inheritable'
require 'pathfinder/finders/a_star'

class Location < ActiveRecord::Base

  include StInheritable
  include Pathfinder::Finders

  has_one :current_character, class_name: 'Character'
  belongs_to :game

  validates_presence_of :type

  class << self
    def generate!(game=nil)
      self.create!({game: game}).tap do |location|
        postition = location.rand_open_position

        x = postition[:x]
        y = postition[:y]

        npc = Characters::Human.generate_npc!
        location.characters << npc
        location.spawn([npc])

        location.buildings << Building.create!(bottom_left_x:x, bottom_left_y: y)
      end
    end
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
  end

  def rand_open_position
    _json_map = json_map

    _json_map.clone.each do |k, unwalkable|
      if k.is_a?(Array) && k.size > 2
        _json_map[k.take(2)] = unwalkable
      end
    end

    attempts = max_x + max_y + max_z
    attempts.times do
      position = rand_position
      unless _json_map[[position[:x],position[:y]]]
        return position
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
  # add initiative order?
  def next_current_character(time=nil, tick_time=TICK_TIME)
    return unless characters.pcs.present?

    time ||= game.time
    time_s = time.to_i

    _characters = characters
    slices = []

    _count = 0

    while true do
      utc_t = Time.at(time_s).utc

      slices << json_map

      _count += 1
      raise "Out of Control" if _count > 1000

      _characters.each do |c|
        if c.idle?(utc_t)
          if c.is_pc
            # pc's turn
            return {
              pc: c,
              time: utc_t
            }
          else
            c.start_action!(:run, rand_open_position, time)
          end
        else
          c.tick(utc_t)
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
    # characters other than the current character can take action before their turn
    time ||= game.time

    if character.id != current_character_id
      # TODO - prevent this fo' real some time
      puts "#{character.id}) It is not #{character.name}'s turn!"
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

  def spawn(characters)
    characters.each do |character|
      character.update_attributes!(
        rand_open_position.merge(
          {
            location_id: id
          }
        )
      )
    end
  end

  def visible_sprites
    characters.visible
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

  def json_map
    sprites_map = visible_sprites.inject({}) do |acc, sprite|
      acc[sprite.position_a] = sprite
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
end

