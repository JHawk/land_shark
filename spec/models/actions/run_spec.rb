require 'spec_helper'

describe Actions::Run do

  describe ".generate!" do
    let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1 }

    let(:path) {
      [
        [0,0,1],
        [1,1,1],
        [2,2,1]
      ]
    }

    let(:started_at) { Time.now }

    subject {
      Actions::Run.generate!(
        {
          character: character,
          ticks: 1,
          started_at: started_at
        },
        path
      )
    }

    it 'sets the finished_at' do
      result = subject

      expect(result.finished_at).to eq(started_at + 2)
      expect(result.character).to eq(character)
    end
  end

  describe "#tick" do
    let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1 }

    let(:path) {
      [
        [0,0,1],
        [1,1,1],
        [2,2,1]
      ]
    }

    let(:started_at) { Time.now }

    let(:action) do
      Actions::Run.generate!(
        {
          character: character,
          ticks: 1,
          started_at: started_at
        },
        path
      )
    end

    subject { action.tick(time) }

    context 'when not finished' do
      let(:finished_at) {1.hour.from_now}
      let(:time) { finished_at - 1.hour }

      it 'should update the ticks' do
        action = subject

        expect(action.ticks).to eq(2)
        #expect(character.position_a).to eq([1,1,1])
      end
    end
  end
end

