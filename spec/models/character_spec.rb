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
  it { should have_many(:relationships) }
  it { should have_many(:acquaintances) }

  it { should belong_to(:equipped_item) }
  it { should belong_to(:occupation) }
  it { should belong_to(:target_character) }
  it { should belong_to(:current_action) }
  it { should belong_to(:location) }
  it { should belong_to(:encounter) }
  it { should belong_to(:game) }

  describe "#relationships" do
    let(:character) { create :npc }
    let(:enemy) { create :npc }
    let(:friend) { create :npc }

    before do
      character.relationships.create(acquaintance: enemy, rating: -10)
      character.relationships.create(acquaintance: friend, rating: 10)
    end

    describe "#enemies" do
      subject { character.acquaintances.enemies }

      it { is_expected.to include(enemy) }
      it { is_expected.not_to include(friend) }
    end

    describe "#allies" do
      subject { character.acquaintances.allies }

      it { is_expected.to include(friend) }
      it { is_expected.not_to include(enemy) }
    end
  end

  describe ".generate!" do
    subject { Characters::Human.generate! }

    it { subject.id.should_not be_nil }
    it { subject.occupation.should_not be_nil }
    it { subject.can? :run }
  end

  describe ".generate_pc!" do
    subject { Characters::Human.generate_pc! }

    it { subject.is_pc.should be_truthy }
  end

  describe ".generate_npc!" do
    subject { Characters::Human.generate_npc! }

    it { subject.is_pc.should be_falsey }
  end

  describe "#decide_target" do
    let(:character) { create :npc }

    subject { character.decide_target }

    context 'when character has a current target' do
      context 'when character has a current target' do
        let(:current_target) { create :npc, is_dead: is_dead }
        before do
          character.update_attributes!(target_character: current_target)
        end

        context 'when current target is alive' do
          let(:is_dead) { false }

          it 'keeps the same target' do
            expect { subject }.not_to change { character.target_character }
          end
        end

        context 'when current target is dead' do
          let(:is_dead) { true }

          it 'targets nothing' do
            expect { subject }.to change { character.target_character }.to(nil)
          end

          context 'when another enemy is present' do
            let!(:other_enemy) { create :npc }
            let!(:relationship) { create :relationship, character: character, rating: -10, acquaintance: other_enemy }

            it 'targets the new enemy' do
              expect { subject }.to change { character.target_character }.from(current_target).to(other_enemy)
            end
          end
        end
      end

    end
  end

  describe "#decide_action" do
    let(:character) { create :npc }

    subject { character.decide_action }

    context 'when character has no actions' do
      it { is_expected.to be_nil }
    end

    context 'when character has an action' do
      let!(:action) { create :run, character: character }

      it { is_expected.to eq(action) }

      it 'sets the current action' do
        expect { subject }.to change { character.current_action }.to(action)
      end
    end
  end

  describe "#decide_path" do
    let(:location) { create :location }
    let(:character) { create :npc, location: location, x:1, y:1, z:1 }

    before do
      character.update_attributes!(target_character: current_target)
    end

    subject { character.decide_path }

    context 'when character has no target' do
      let(:current_target) { nil }

      it { is_expected.to be_a(Hash) }
    end

    context 'when character has a target' do
      let(:current_target) { create :npc, location: location, x:1, y:4, z:1 }

      it { is_expected.to eq(current_target.position) }

      it 'sets the path' do
        expect { subject }.to change { character.path }
      end
    end
  end

  describe "#hate!" do
    let(:character) { create :npc }
    let(:other_character) { create :npc }

    subject { character.hate!(other_character) }

    context 'when the character does not have a relationship with the other character' do
      it 'creates a new enemy relationship' do
        subject

        expect(character.enemies).to include(other_character)
      end
    end

    context 'when the character has a relationship with the other character' do
      let!(:relationship) do
        character.relationships.create!(acquaintance: other_character, rating: 5)
      end

      it 'updates the relationship' do
        subject

        expect(character.enemies).to include(other_character)
        expect(relationship.reload.rating).to eq(-5)
      end
    end

  end

  describe "#tick" do
    let(:character) { create :npc, is_dead: is_dead}
    let(:action) { create :run, character: character }
    let(:time) { Time.zone.now }

    before do
      allow(action).to receive(:tick)

      character.current_action = action
    end

    subject { character.tick(time) }

    context 'when character is dead' do
      let(:is_dead) { true }

      it 'does not tick the current action' do
        expect(action).not_to receive(:tick)

        subject
      end
    end

    context 'when character is alive' do
      let(:is_dead) { false }

      it 'ticks the current action' do
        expect(action).to receive(:tick)

        subject
      end
    end
  end

  describe "#equip!" do
    let(:character) { FactoryGirl.create :pc }
    let(:item) { FactoryGirl.create :item }

    context "when character has items" do
      subject { character.equip! }

      before do
        character.items << item
      end

      it 'sets the item to the equipped item' do
        subject

        expect(character.reload.equipped_item).to eq(item)
      end

      context "when character doesn't have the item in their inventory" do
        let(:new_item) { FactoryGirl.create :item }

        subject { character.equip!(new_item) }

        it 'sets the new item to the equipped item' do
          expect {subject}.to raise_error(Exception)
        end
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

      it { should be_truthy }
    end

    context "when current_action is present" do
      context "when current_action is finished" do
        let(:current_action) { FactoryGirl.create :action, finished_at: time - 1.hour }

        it { should be_truthy }
      end

      context "when current_action is not finished" do
        let(:current_action) { FactoryGirl.create :action, finished_at: time + 1.hour }

        it { should be_falsey }
      end
    end
  end

  describe "#can?" do
    let(:character) { FactoryGirl.create :pc }

    subject { character.can? action_name }

    context "when action is nil" do
      let(:action_name) { nil }

      it { should be_falsey }
    end

    context "when character has action" do
      let(:action_name) { 'run' }
      let!(:action) { FactoryGirl.create :action, character: character }

      it { should be_truthy }
    end

    context "when character has action with a requirement" do
      let(:action_name) { 'throw' }
      let!(:action) { FactoryGirl.create :throw, character: character }

      context 'when character has no equipped item' do
        it { should be_falsey }
      end

      context 'when character has an equipped item' do
        let(:item) { FactoryGirl.create :item, character: character }

        before do
          character.update_attributes!(equipped_item: item)
        end

        it { should be_truthy }
      end
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

  describe "#dies!" do
    let(:character) { FactoryGirl.create :character }

    subject { character.dies! }

    it { subject.is_dead?.should be_truthy }

    context "when character is part of an encounter" do
      let(:encounter) { FactoryGirl.create :encounter }

      before do
        character.update_attributes!(encounter_id: encounter.id)
      end

      it "notifies the encounter" do
        Encounter.any_instance.should_receive(:check_complete!)

        subject
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

