require 'spec_helper'

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

