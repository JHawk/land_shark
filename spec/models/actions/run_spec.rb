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

  end

  describe "#start!" do
    let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1, path: "[[0,0,1],[1,1,1],[2,2,2]]" }
    let(:action) { Actions::Run.create! character: character }
    let(:time) { Time.zone.now }

    subject { action.start!(time) }

    it 'sets the finished_at' do
      subject

      expect(action.reload.started_at).to eq(time)
      expect(action.reload.finished_at).to eq(time + 2)
    end
  end

  describe "#tick" do
    let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1, path: "[[0,0,1],[1,1,1],[2,2,2]]", game: game }
    let(:action) { Actions::Run.create! character: character }
    let(:game) { FactoryGirl.create :game }

    let(:started_at) { Time.now }

    subject { action.tick(time) }

    context 'when not finished' do
      let(:finished_at) {1.hour.from_now}
      let(:time) { finished_at - 1.hour }

      it 'should update the ticks' do
        action = subject

        expect(action.ticks).to eq(1)
        expect(character.reload.position_a).to eq([1,1,1])
      end
    end
  end
end

