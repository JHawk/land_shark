FactoryGirl.define do
  def rand_attribute
    rand(20) + 1
  end

  factory :character do
    name { Faker::Name.name }

    strength { binding.pry ; rand_attribute }
    dexterity { rand_attribute }
    constitution { rand_attribute }
    intelligence { rand_attribute }
    wisdom { rand_attribute }
    charisma { rand_attribute }
  end
end

