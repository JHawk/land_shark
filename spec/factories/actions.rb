FactoryGirl.define do
  factory :action do
    type { 'Actions::Run' }
    ticks { 0 }
    character { FactoryGirl.create :character }
  end

  factory :action_run do
    type { 'Actions::Run' }
    ticks { 0 }
    character { FactoryGirl.create :character }
  end

  factory :throw, class: Actions::Throw do
    ticks { 0 }
    character { FactoryGirl.create :character }
  end
end

