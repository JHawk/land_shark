require 'spec_helper'
require 'pathfinder/finders/a_star'

describe Location do
  it { should have_many(:characters) }

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

  describe "#move!" do
    subject { location.move!(character, position) }

    context "when character is at location" do
      let(:location) { character.location }
      let(:character) { FactoryGirl.create :character_visible_at_location, x:2, y:2, z:1, land_speed:5 }

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
end

