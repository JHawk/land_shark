require 'spec_helper'

describe Character do
  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:strength) }
  it { should validate_presence_of(:agility) }
  it { should validate_presence_of(:hit_points) }

  it { should validate_presence_of(:perception) }
  it { should validate_presence_of(:intelligence) }
  it { should validate_presence_of(:sanity) }

  it { should validate_presence_of(:focus) }
  it { should validate_presence_of(:willpower) }
  it { should validate_presence_of(:essence) }

  it { should validate_presence_of(:charisma) }

  it { should validate_presence_of(:land_speed) }

  it { should have_many(:actions) }
  it { should have_many(:moves) }

  it { should belong_to(:equipped_item) }
  it { should belong_to(:occupation) }
  it { should belong_to(:target_character) }
  it { should belong_to(:current_action) }
  it { should belong_to(:location) }
  it { should belong_to(:game) }

  describe ".generate!" do
    subject { Characters::Human.generate! }

    it { subject.id.should_not be_nil }
    it { subject.occupation.should_not be_nil }
    it { subject.can? :run }
  end

  describe ".generate_pc!" do
    subject { Characters::Human.generate_pc! }

    it { subject.is_pc.should be_true }
  end

  describe ".generate_npc!" do
    subject { Characters::Human.generate_npc! }

    it { subject.is_pc.should be_false }
  end

  describe "#equip!" do
    let(:character) { FactoryGirl.create :pc }
    let(:item) { FactoryGirl.create :item }

    subject { character.equip! }

    context "when character has items" do
      before do
        character.items << item
      end

      it 'sets the item to the equipped item' do
        subject

        expect(character.reload.equipped_item).to eq(item)
      end
    end
  end

  describe "#generate_equipment!" do
    let(:character) { FactoryGirl.create :pc }

    subject { character.generate_equipment! }

    it 'add an item to the inventory' do
      subject

      expect(character.reload.items).to be_present
      expect(character.reload.equipped_item).not_to be_nil
    end
  end

  describe ".#generate_characteristics" do
    subject { Characters::Human.generate_characteristics }

    it 'will generate attributes' do
      characteristics = subject

      expect(characteristics[:name]).to be_present

      expect(characteristics[:strength]).to be_present
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

  describe "#can?" do
    let(:character) { FactoryGirl.create :pc }

    subject { character.can? action_name }

    context "when action is nil" do
      let(:action_name) { nil }

      it { should be_false }
    end
  end

  describe "#drop_current_position" do
    let(:character) { Character.new(x: 1, y: 2, z: 3) }
    let(:path) do
      [
        [0,0,0],
        [1,2,3],
        [1,2],
        [2,2,2]
      ]
    end

    subject { character.drop_current_position(path) }

    it { should eq([[0,0,0],[2,2,2]]) }
  end

  describe "#take_step!" do
    let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1, path: path, game: game }
    let(:game) { FactoryGirl.create :game }

    subject { character.take_step! }

    context 'when path remaining' do
      let(:path) { "[[0,0,1],[1,1,1],[2,2,2]]" }

      it "updates the character" do
        result = subject

        expect(character.reload.path).to eq('[[1,1,1],[2,2,2]]')
        expect(character.reload.position_a).to eq([1,1,1])
      end

      it 'creates a move' do
        result = subject

        expect(character.reload.moves).not_to be_empty
      end
    end

    context 'when path is not remaining' do
      let(:path) { "[]" }

      it "skips update" do
        result = subject

        expect(character.reload.path).to eq('[]')
        expect(character.reload.position_a).to eq([0,0,1])
      end
    end

    context 'when remaining path is nil' do
      let(:path) { nil }

      it "skips update" do
        result = subject

        expect(character.reload.path).to be_nil
        expect(character.reload.position_a).to eq([0,0,1])
      end
    end
  end

  describe "#path_a" do
    let(:character) { FactoryGirl.create :character, path: path }

    subject { character.path_a }

    context "when path is array" do
      let(:path) { "[1]" }

      it { should_not be_empty }
    end

    context "when path is not array" do
      let(:path) { "{\"a\":1}" }

      it { should be_empty }
    end

    context "when path is not valid" do
      let(:path) { "1" }

      it { should be_empty }
    end

    context "when path is nil" do
      let(:path) { nil }

      it { should be_empty }
    end
  end

  describe "#action_by_type" do
    let(:character) { FactoryGirl.create :character }
    let(:action) { FactoryGirl.create :action, character: character }

    subject { character.action_by_type(action_type) }

    context 'character has an action of that type' do
      let(:action_type) { 'run' }

      it { should eq(Actions::Run.first) }
    end

    context 'character has no action of that type' do
      let(:action_type) { 'does not exist' }

      it { should be_nil }
    end
  end

  describe "#position_a" do
    let(:character) { Character.new(x: 1, y: 2, z: 3) }
    subject { character.position_a }

    it { subject[0].should eq 1 }
    it { subject[1].should eq 2 }
    it { subject[2].should eq 3 }
  end

  describe "#position_a" do
    let(:character) { Character.new(x: 1, y: 2, z: 3) }
    subject { character.position_a }

    it { subject[0].should eq 1 }
    it { subject[1].should eq 2 }
    it { subject[2].should eq 3 }
  end
end

