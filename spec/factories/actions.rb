FactoryGirl.define do
  factory :action do
    type { 'Actions::Run' }
    ticks { 0 }
    character { FactoryGirl.create :character }
  end
end

