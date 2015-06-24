FactoryGirl.define do
  factory :game do
    user { FactoryGirl.create :user }
  end

  trait :with_no_encounters do
    after(:create) do |instance|
      instance.encounters.map(&:destroy!)
    end
  end
end

