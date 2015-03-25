require 'spec_helper'

describe Game do
  it { should belong_to(:user) }
  it { should have_many(:locations) }
  it { should have_many(:characters) }

  it { should validate_presence_of(:user) }

  describe "after_create" do
    let(:game) { FactoryGirl.create :game }

    it 'will set the time' do
      expect(game.time).not_to be_nil
    end

    it 'will create a new character' do
      expect(game.characters.count).to be > 1
      expect(game.characters.name).not_to be_nil
    end

    it 'will create new locations' do
      expect(game.hospital).not_to be_nil
      expect(game.police_station).not_to be_nil
    end
  end

  describe "#recent_moves" do
    let(:game) { FactoryGirl.create :game }

    before do
      game.current_location!
    end

    subject { game.recent_moves }

    context 'no prior_action_at' do
      it {should be_empty}
    end
  end

  describe "#json_map" do
    let(:game) { FactoryGirl.create :game }

    before do
      game.current_location!
    end

    subject { game.json_map }

    it 'should contain the locations visible info' do
      game_map = subject

      characters = game.current_location.characters

      expect(game_map.values).to include(characters.first)
    end

  end

  describe "#open_position_near" do
    let(:location) { FactoryGirl.create :location }
    let(:position) {{x:10, y:10, z:1}}

    subject { location.open_position_near(position) }

    it 'should be close to the given position' do
      result = subject

      expect(result[:x]).to be >= 8
      expect(result[:x]).to be <= 12

      expect(result[:y]).to be >= 8
      expect(result[:y]).to be <= 12
    end
  end

  describe "#move!" do
    let(:game) { FactoryGirl.create :game }
    let(:location) { game.current_location! }
    let(:character) { location.current_character }

    before do
      location.spawn character
    end

    context 'when character not at the location' do
      before do
        character.location = nil
        character.save
      end

      subject { game.move! character, location.rand_open_position, :run}

      it 'skips the update' do
        expect { subject }.to raise_error
      end
    end
  end
end

