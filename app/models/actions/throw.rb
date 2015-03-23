class Actions::Throw < Action
  class << self
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
    target = character.target_character
    item = character.equipped_item

    character.ranged_attack(target).with(item).resolve!

    item.update_attributes!(character_id: nil)
    character.update_attributes!(equipped_item_id: nil)
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

