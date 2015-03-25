require 'spec_helper'

describe Encounter do
  it { should have_many(:npcs) }
  it { should belong_to(:location) }

  it { should validate_presence_of(:name) }

  describe '.generate_at!' do
    let(:location) { FactoryGirl.create :location }

    subject { Encounter.generate_at!(location) }

    it { subject.reload.location_id.should eq(location.id) }
    it { subject.reload.npcs.should_not be_empty }
  end
end

