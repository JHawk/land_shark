FactoryGirl.define do
  factory :action do
    type { 'Actions::Run' }
    ticks { 0 }
    character { FactoryGirl.create :character }
  end

  factory :run, class: Actions::Run do
    ticks { 0 }
    character { FactoryGirl.create :character }
  end

  factory :throw, class: Actions::Throw do
    ticks { 0 }
    character { FactoryGirl.create :character }
  end
end

