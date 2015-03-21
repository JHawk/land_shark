class Actions::HunkerDown < Action
  class << self
  end

  def start!(time)
    super(time)

    self.update_attributes!(finished_at: started_at + 5.seconds)
  end

  def tick(time)
    super(time)
  end
end

