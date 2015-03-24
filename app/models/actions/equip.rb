class Actions::Equip < Action
  class << self
  end

  def equip_time
    2.seconds
  end

  def tick(time)
    super(time)
  end

  def start!(time)
    super(time)

    _fin = started_at + equip_time

    self.update_attributes!({
      finished_at: _fin
    })
  end

  def on_finish
    character.equip!
  end
end

