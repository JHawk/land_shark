FactoryGirl.define do
  factory :character do
    name { Faker::Name.name }

    strength { rand(20) + 1 }
    dexterity { rand(20) + 1 }
    constitution { rand(20) + 1 }
    intelligence { rand(20) + 1 }
    wisdom { rand(20) + 1 }
    charisma { rand(20) + 1 }

    land_speed { rand(20) + 1 }

    factory :character_visible_at_location do
      location { FactoryGirl.create :location }
      x { rand(100) }
      y { rand(100) }
      z { rand(100) }
    end
  end
end

