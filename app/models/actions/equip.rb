class Actions::Equip < Action
  class << self
  end

  def combat?
    true
  end

  def ready?
    character.items.present?
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
    super
    character.equip!
  end
end

