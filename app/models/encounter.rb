class Encounter < ActiveRecord::Base
  has_many :npcs, class_name: 'Character'
  belongs_to :location

  validates_presence_of :location, :name

  class << self
    def generate_name(npcs=nil)
      "Take out #{npcs.map(&:name).join(', ')}"
    end

    def generate_at!(location)
      npcs = location.generate_npc_group!(2)

      encounter = create!(location_id: location.id, name: generate_name(npcs))
      npcs.each do |npc|
        npc.update_attributes!(encounter_id: encounter.id)
      end
      encounter.reload
    end
  end
end

