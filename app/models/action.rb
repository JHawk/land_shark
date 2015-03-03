class Action < ActiveRecord::Base
  belongs_to :character

  def tick(time)
    self.ticks += 1
    self.last_ticked_at = time
    self.save
    self
  end

  # use last ticked at instead of passing around the time
  def finished?(time=last_ticked_at)
    finished_at < time
  end

=begin
  def ready?(time)
  end

  def started?(time)
  end
=end
end

