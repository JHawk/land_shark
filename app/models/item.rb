require 'positionable'

class Item < ActiveRecord::Base
  include Positionable

  validates_presence_of :name

  belongs_to :character
  belongs_to :location
end

