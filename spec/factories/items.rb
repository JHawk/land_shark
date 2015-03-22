FactoryGirl.define do
  factory :item do
    name { "knife" }
    damage { rand 5 }
  end
end

