require 'spec_helper'

describe Character do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:strength) }
  it { should validate_presence_of(:dexterity) }
  it { should validate_presence_of(:constitution) }
  it { should validate_presence_of(:intelligence) }
  it { should validate_presence_of(:wisdom) }
  it { should validate_presence_of(:charisma) }

  it { should belong_to(:location) }
  it { should belong_to(:game) }

  describe ".generate!" do
    subject { Character.generate! }

    it { subject.id.should_not be_nil }
  end

  describe ".#generate_characteristics" do
    subject { Character.generate_characteristics }

    it 'will generate attributes' do
      characteristics = subject

      expect(characteristics[:name]).to be_present

      expect(characteristics[:strength]).to be_present
      expect(characteristics[:dexterity]).to be_present
      expect(characteristics[:constitution]).to be_present
    end
  end

  describe "#position" do
    let(:character) { Character.new(x: 1, y: 2, z: 3) }
    subject { character.position }

    it { subject[0].should eq 1 }
    it { subject[1].should eq 2 }
    it { subject[2].should eq 3 }
  end
end

