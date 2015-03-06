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
      expect(game.characters.count).to eq(1)
      expect(game.characters.name).not_to be_nil
    end

    it 'will create a new location' do
      expect(game.locations.count).to eq(1)
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

    subject { game.json_map }

    it 'should contain the locations visible info' do
      game_map = subject

      characters = game.current_location.characters

      expect(game_map.values).to include(characters.first)
    end

  end

  describe "#move!" do
    let(:game) { FactoryGirl.create :game }
    let(:location) { game.current_location! }
    let(:character) { location.current_character }

    before do
      location.spawn [character]
    end

    subject { game.move! character, location.rand_open_position}

    context 'when character not at the location' do
      before do
        character.location = nil
        character.save
      end

      it 'skips the update' do
        start_time = game.time

        subject

        expect(game.reload.time).to eq(start_time)
      end
    end

    context 'when character at the location' do
      it 'updates the game correctly' do
        start_time = game.time

        subject

        expect(game.reload.time).to be > start_time
        expect(game.reload.prior_action_at).to eq(start_time)
      end
    end
  end
end

