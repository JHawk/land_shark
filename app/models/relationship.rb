class Relationship < ActiveRecord::Base
  belongs_to :character
  belongs_to :acquaintance, class_name: 'Character'

  validates_presence_of :character, :rating, :acquaintance
  validates_uniqueness_of :character, scope: :acquaintance
end
