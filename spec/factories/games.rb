FactoryGirl.define do
  factory :game do
    user { FactoryGirl.create :user }

    after(:create) do |instance|
      instance.set_time!
    end
  end

  trait :with_setup do
    after(:create) do |instance|
      instance.setup!
    end
  end

  trait :with_no_encounters do
    after(:create) do |instance|
      instance.generate_characters!
      instance.generate_locations!
    end
  end
end

