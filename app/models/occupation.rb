require 'st_inheritable'

class Occupation < ActiveRecord::Base
  include StInheritable

  has_many :characters

  validates_presence_of :type

  class << self
    def random
      Occupation.st_types.sample
    end
  end
end

