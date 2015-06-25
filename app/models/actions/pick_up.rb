class Actions::PickUp < Action
  class << self
  end

  def ready?
    character.target_item.present?
  end

  def start!(time)
    super(time)

    _fin = started_at + aim + follow_through
    self.update_attributes!({
      finished_at: _fin
    })
  end

  def aim
    1.seconds
  end

  def delivery
    unless finished?
      target = character.target_item
      character.items << target
      update_attributes!(finished: true)
    end
  end

  def follow_through
    1.seconds
  end

  def deliver_at
    started_at + aim
  end

  def tick(time)
    if time > deliver_at
      delivery
    end

    super(time)
  end
end

