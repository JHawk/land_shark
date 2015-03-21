class Item < ActiveRecord::Base
  validates_uniqueness_of :name
  validates_presence_of :name

  belongs_to :character
end

