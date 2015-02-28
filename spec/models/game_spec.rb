require 'spec_helper'

describe Game do
  it { should belong_to(:user) }
  it { should have_many(:locations) }
  it { should have_many(:characters) }

  it { should validate_presence_of(:user) }

  describe "after_create" do
    let(:game) { FactoryGirl.create :game }

    it 'will create a new character' do
      expect(game.characters.count).to eq(1)
      expect(game.characters.name).not_to be_nil
    end

    it 'will create a new location' do
      expect(game.locations.count).to eq(1)
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
end

