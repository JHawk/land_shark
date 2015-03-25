FactoryGirl.define do
  factory :encounter do
    name { "encounter" }
    location { FactoryGirl.create :location }
  end
end

