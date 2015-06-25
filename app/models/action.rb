require 'st_inheritable'
require 'errors/action_not_started_error'

class Action < ActiveRecord::Base
  include StInheritable

  belongs_to :character

  validates_presence_of :character

  def start!(time)
    self.update_attributes!({
      finished: false,
      started_at: time
    })
  end

  def tick(time)
    raise Errors::ActionNotStartedError unless started?

    self.ticks += 1

    if times_up?(time) && (!last_ticked_at || !times_up?)
      on_finish
    end

    self.last_ticked_at = time
    self.save
    self
  end

  def combat?
    false
  end

  def noncombat?
    !combat?
  end

  def ready?
    true
  end

  # use last ticked at instead of passing around the time
  def times_up?(time=last_ticked_at)
    finished || finished_at <= time
  end

  def on_finish
    update_attributes!(finished: true)
  end

  def started?
    !started_at.nil?
  end

  def ensure_finalized!
    if times_up? && !finished?
      on_finish
    end
  end
end

