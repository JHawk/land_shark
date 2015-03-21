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
    target = Character.find character.target_character_id
    item = Item.find character.equipped_item_id

    target.hit_points = target.hit_points - item.damage
    target.save!

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

