FactoryGirl.define do
  factory :relationship do
    character
    acquaintance { create :npc }
    rating { rand(10) }
  end
end

