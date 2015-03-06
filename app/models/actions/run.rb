class Actions::Run < Action
  class << self
  end

  def start!(time)
    super(time)

    self.update_attributes!(finished_at: started_at + character.remaining_path_a.length)
  end

  def tick(time)
    character.take_step!
    super(time)
  end
end

