FactoryGirl.define do
  factory :game do
    user { FactoryGirl.create :user }
  end
end

