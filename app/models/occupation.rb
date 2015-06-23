class Occupation < ActiveRecord::Base

  validates_presence_of :name
  has_many :characters
  validates_uniqueness_of :name

  class << self
    def random
      Occupation.all.sample
    end
  end
end

