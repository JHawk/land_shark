require 'spec_helper'

describe Character do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:strength) }
  it { should validate_presence_of(:dexterity) }
  it { should validate_presence_of(:constitution) }
  it { should validate_presence_of(:intelligence) }
  it { should validate_presence_of(:wisdom) }
  it { should validate_presence_of(:charisma) }

  it { should have_many(:actions) }

  it { should belong_to(:current_action) }
  it { should belong_to(:location) }
  it { should belong_to(:game) }

  describe ".generate!" do
    subject { Character.generate! }

    it { subject.id.should_not be_nil }
  end

  describe ".generate_pc!" do
    subject { Character.generate_pc! }

    it { subject.is_pc.should be_true }
  end

  describe ".generate_npc!" do
    subject { Character.generate_npc! }

    it { subject.is_pc.should be_false }
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

  describe "#idle?" do
    let(:character) { FactoryGirl.create :character }
    let(:time) { 1.hour.from_now }

    subject { character.idle?(time) }

    before do
      character.current_action = current_action
      character.save
    end

    context "when no current_action" do
      let(:current_action) { nil }

      it { should be_true }
    end

    context "when current_action is present" do
      context "when current_action is finished" do
        let(:current_action) { FactoryGirl.create :action, finished_at: time - 1.hour }

        it { should be_true }
      end

      context "when current_action is not finished" do
        let(:current_action) { FactoryGirl.create :action, finished_at: time + 1.hour }

        it { should be_false }
      end
    end
  end

  describe "#position_a" do
    let(:character) { Character.new(x: 1, y: 2, z: 3) }
    subject { character.position_a }

    it { subject[0].should eq 1 }
    it { subject[1].should eq 2 }
    it { subject[2].should eq 3 }
  end
end

