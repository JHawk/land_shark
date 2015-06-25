class Actions::Throw < Action
  class << self
  end

  def combat?
    true
  end

  def ready?
    character.equipped_item.present?
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
      target = character.target_character
      item = character.equipped_item

      character.ranged_attack(target).with(item).resolve!

      item.update_attributes!({
        character_id: nil,
        location_id: character.location_id,
        x: target.x,
        y: target.y,
        z: target.z
      })

      character.update_attributes!(equipped_item_id: nil)

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

