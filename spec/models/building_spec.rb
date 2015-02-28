require 'spec_helper'

describe Building do
  it { should belong_to(:location) }

  describe "#grid" do
    let(:building) { Building.new }

    subject { building.grid }

    it { should_not be_empty }
  end
end

