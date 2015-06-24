require 'spec_helper'

describe Building do
  it { should belong_to(:location) }

  describe "#grid" do
    let(:building) { Building.new(bottom_left_x: 10, bottom_left_y: 10) }

    subject { building.grid }

    it { should_not be_empty }

    it 'is offset correctly' do
      grid = subject

      expect(grid[[11,10]][:walkable]).to be_falsey
      expect(grid[[19,14]][:walkable]).to be_falsey
    end
  end

  describe "#grid_rep" do
    let(:building) { Building.new }

    subject { building.grid }

    it { should_not be_empty }
  end
end

