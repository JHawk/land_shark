require 'spec_helper'

describe Actions::Run do
  let(:action) { Actions::Run.new ticks: 1 }

  describe "#tick" do
    subject { action.tick(time) }

    context 'when not finished' do
      let(:finished_at) {1.hour.from_now}
      let(:time) { finished_at - 1.hour }

      it 'should not update the ticks' do
        action = subject

        expect(action.ticks).to eq(2)
      end
    end
  end
end

