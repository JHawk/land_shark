FactoryGirl.define do
  factory :character do
    name { Faker::Name.name }

    agility { rand(20) + 1 }
    strength { rand(20) + 1 }
    hit_points { rand(20) + 1 }

    perception { rand(20) + 1 }
    intelligence { rand(20) + 1 }
    sanity { rand(20) + 1 }

    focus { rand(20) + 1 }
    willpower { rand(20) + 1 }
    essence { rand(20) + 1 }

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

