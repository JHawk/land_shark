class Occupation < ActiveRecord::Base

  validates_presence_of :name
  has_many :characters

  class << self
    def random
      Occupation.all.sample
    end
  end
end

