class Action < ActiveRecord::Base
  belongs_to :character

  def tick(time)
    self.ticks += 1 unless finished?(time)
    self
  end

  def finished?(time)
    finished_at < time
  end

=begin
  def ready?(time)
  end

  def started?(time)
  end
=end
end

