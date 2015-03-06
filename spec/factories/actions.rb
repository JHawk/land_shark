FactoryGirl.define do
  factory :action do
    type { 'Actions::Run' }
    ticks { 0 }
    started_at { Time.now }
    character { FactoryGirl.create :character }
  end
end

