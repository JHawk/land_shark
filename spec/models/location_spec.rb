require 'spec_helper'
require 'pathfinder/finders/a_star'

describe Location do
  it { should have_many(:characters) }
  it { should have_many(:buildings) }
  it { should have_one(:current_character) }
  it { should belong_to(:game) }

  describe ".generate!" do
    subject { Location.generate! }

    it { subject.buildings.should_not be_empty }
    it { subject.buildings.first.bottom_left_x.should_not be_nil }
    it { subject.buildings.first.bottom_left_y.should_not be_nil }

    it { subject.characters.npcs.should_not be_empty }
  end

  describe "characters.npcs" do
    subject { location.characters.npcs }

    context 'belongs to a location' do
      let(:x) { 1 }
      let(:y) { 1 }
      let(:z) { 1 }

      let(:location) { FactoryGirl.create :location }
      let(:character) { FactoryGirl.create :character, location: location, x: x, y: y, z: z, is_pc: is_pc }

      context 'when pc' do
        let(:is_pc) { true }

        context 'all positions present' do
          it { should_not include(character) }
        end
      end

      context 'when npc' do
        let(:is_pc) { false }
        context 'all positions present' do
          it { should include(character) }
        end

        context 'character missing x position' do
          let(:x) { nil }

          it { should_not include(character) }
        end

        context 'character missing y position' do
          let(:y) { nil }

          it { should_not include(character) }
        end

        context 'character missing z position' do
          let(:z) { nil }

          it { should_not include(character) }
        end
      end
    end
  end

  describe "characters.visible" do
    subject { location.characters.visible }

    context 'belongs to a location' do
      let(:x) { 1 }
      let(:y) { 1 }
      let(:z) { 1 }

      let(:location) { FactoryGirl.create :location }
      let(:character) { FactoryGirl.create :character, location: location, x: x, y: y, z: z }

      context 'all positions present' do
        it { should include(character) }
      end

      context 'character missing x position' do
        let(:x) { nil }

        it { should_not include(character) }
      end

      context 'character missing x position' do
        let(:y) { nil }

        it { should_not include(character) }
      end

      context 'character missing x position' do
        let(:z) { nil }

        it { should_not include(character) }
      end
    end
  end

  describe "#spawn" do
    let(:characters) { [ character ] }

    subject { location.spawn(characters) }

    context "when character not at location" do
      let(:character) { FactoryGirl.create :character }
      let(:location) { FactoryGirl.create :location }

      it 'places the character' do
        subject

        expect(character.reload.location).to eq(location)

        expect(character.reload.x).not_to be_nil
        expect(character.reload.y).not_to be_nil
        expect(character.reload.z).not_to be_nil
      end
    end
  end

  describe "#next_current_character" do
    let(:time) { 1.minute.ago }
    let(:tick_time) { 1.minute }

    subject { location.next_current_character(time, tick_time) }

    context "when no characters present" do
      let(:location) { FactoryGirl.create :location }
      it { should be_nil }
    end

    context "when no pc characters present" do
      let(:location) { character.location }
      let(:character) { FactoryGirl.create :character_visible_at_location, x:2, y:2, z:1, land_speed:5, is_pc: false }

      it { should be_nil }
    end

    context "when a pc character is present" do
      let!(:location) { pc.location }

      let!(:pc) { FactoryGirl.create :character_visible_at_location, x:1, y:2, z:0, land_speed:5, is_pc: true }

      let!(:npc) { FactoryGirl.create :character, location_id: location.id, is_pc: false }

      context "when pc character is idle" do
        it { should eq(pc) }
      end

      context "when pc character is not idle" do
        let(:action) { FactoryGirl.create :action, finished_at: 1.minute.from_now}
        before do
          pc.current_action = action
          pc.save
        end

        it 'ticks the characters until a pc is available' do
          result = subject

          # expect(pc.position).to eq(updated)
          expect(result).to eq(pc)
        end
      end
    end
  end

  describe "#move!" do
    subject { location.move!(character, position) }

    context "when character is npc" do
      let(:location) { character.location }
      let(:character) { FactoryGirl.create :character_visible_at_location, x:2, y:2, z:1, land_speed:5, is_pc: false }

      context 'when character can reach the space' do
        let(:position) { [1,1,1] }

        it { should be_false }
        it "skips the update" do
          subject

          expect(character.reload.x).to eq(2)
          expect(character.reload.y).to eq(2)
          expect(character.reload.z).to eq(1)
        end
      end
    end

    context "when character is at location" do
      let(:location) { character.location }
      let(:character) { FactoryGirl.create :character_visible_at_location, x:2, y:2, z:1, land_speed:5, is_pc: true }

      context 'when character can reach the space' do
        let(:position) { [1,1,1] }

        it { should be_true }
        it "updates the character's position" do
          subject

          expect(character.reload.x).to eq(1)
          expect(character.reload.y).to eq(1)
          expect(character.reload.z).to eq(1)
        end
      end

      context 'when no path exists' do
        let(:position) { [1,1,1] }

        before do
          Pathfinder::Finders::AStar.any_instance.should_receive(:find_path).and_return(nil)
        end

        it { should be_false }

        it "skips the update" do
          subject

          expect(character.reload.x).to eq(2)
          expect(character.reload.y).to eq(2)
          expect(character.reload.z).to eq(1)
        end
      end

      context 'when the path is no distance' do
        let(:position) { [1,1,1] }

        context 'path is empty' do
          before do
            Pathfinder::Finders::AStar.any_instance.should_receive(:find_path).and_return([])
          end

          it { should be_false }

          it "skips the update" do
            subject

            expect(character.reload.x).to eq(2)
            expect(character.reload.y).to eq(2)
            expect(character.reload.z).to eq(1)
          end
        end

        context "path is the character's current position" do
          before do
            Pathfinder::Finders::AStar.any_instance.should_receive(:find_path).and_return([character.position])
          end

          it { should be_false }

          it "skips the update" do
            subject

            expect(character.reload.x).to eq(2)
            expect(character.reload.y).to eq(2)
            expect(character.reload.z).to eq(1)
          end
        end
      end

      context 'when character can not reach the space' do
        let(:position) { [25,25,1] }

        it { should be_false }

        it "skips the character update" do
          subject

          expect(character.reload.x).to eq(2)
          expect(character.reload.y).to eq(2)
          expect(character.reload.z).to eq(1)
        end
      end
    end

    context "when character is not at location" do
      let(:location) { FactoryGirl.create :location }
      let(:position) { [1,1,1] }
      let(:character) { FactoryGirl.create :character, x:2, y:2, z:2, land_speed:5 }

      it { should be_false }

      it "skips the character's updates" do
        subject

        expect(character.reload.x).to eq(2)
        expect(character.reload.y).to eq(2)
        expect(character.reload.z).to eq(2)
      end
    end
  end

  describe "#visible_sprites" do
    subject { location.visible_sprites }

    context "when character is visible" do
      let(:location) { character.location }
      let(:character) { FactoryGirl.create :character_visible_at_location }

      it { should include(character) }
    end

    context "when character is not visible" do
      let(:location) { FactoryGirl.create :location }
      let(:character) { FactoryGirl.create :character, location: location }

      it { should_not include(character) }
    end
  end

  describe "#rand_open_position" do
    let(:location) { FactoryGirl.create :location, max_x:max_x, max_y:max_y, max_z:1 }

    subject {location.rand_open_position}

    context "only one position" do
      let(:max_x) {1}
      let(:max_y) {1}

      context "when position is not occupied" do
        it { should eq({:x=>0, :y=>0, :z=>0}) }
      end

      context "when position is occupied by a character" do
        let(:character) { FactoryGirl.create :character, x:0, y:0, z:0 }

        before do
          location.characters << character
        end

        it { should be_nil }
      end
    end

    context "no positions" do
      let(:max_x) {-1}
      let(:max_y) {-1}

      it { should be_nil }
    end
  end

  describe "#json_map" do

    subject { location.json_map }

    context "when location has a character" do
      let(:location) { FactoryGirl.create :location }
      let(:character) { FactoryGirl.create :character }

      before do
        location.spawn([character])
      end

      it { subject.values.should include(character) }
    end

    context "when location has a building" do
      let(:location) { Location.generate! }
      let(:building) { location.buildings.first }

      let(:position) { building.grid.keys.reject {|key| key.is_a? Symbol}.first }

      it { subject.keys.should include(position) }
    end

    context "when location has a character and a building" do
      let(:location) { Location.generate! }
      let(:character) { FactoryGirl.create :character }
      let(:building) { location.buildings.first }

      let(:position) { building.grid.keys.reject {|key| key.is_a? Symbol}.first }

      before do
        location.spawn([character])
      end

      it { subject.keys.should include(position) }
      it { subject.values.should include(character) }
    end
  end
end

