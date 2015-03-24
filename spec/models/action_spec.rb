require 'spec_helper'

describe Action do
  it { should belong_to(:character) }

  it { should validate_presence_of(:character) }

  describe "#start!" do
    let(:action) { FactoryGirl.create :action, finished: true }
    let(:time) { Time.now }

    subject { action.start!(time) }

    it 'should update the action' do
      subject

      expect(action.reload.started_at.to_i).to eq(time.to_i)
      expect(action.reload.finished?).to be_false
    end
  end

  describe "#tick" do
    let(:finished_at) {1.hour.from_now}
    let(:action) { FactoryGirl.create :action, finished_at: finished_at, ticks: 1, started_at: Time.now }

    subject { action.tick(time) }

    context 'when not finished' do
      let(:time) { finished_at - 1.hour }

      it 'should not update the ticks' do
        action = subject

        expect(action.ticks).to eq(2)
      end
    end
  end

  describe "#ensure_finalized!" do
    let(:finished_at) {1.hour.from_now}
    let(:action) { FactoryGirl.create :action, finished_at: finished_at }

    before do
      action.start!(time)
      action.update_attributes!(last_ticked_at: time)
    end

    subject { action.ensure_finalized! }

    context 'when times up' do
      let(:time) { finished_at + 1.hour }

      context 'when action already finished' do
        before do
          action.update_attributes!(finished: true)
        end

        it 'should do nothing' do
          expect(action).not_to receive(:on_finish)

          subject
        end
      end

      context 'when action not finished' do
        it 'should update the action' do
          expect(action).to receive(:on_finish)

          subject
        end
      end
    end

    context 'when times not up' do
      let(:time) { finished_at - 1.hour }

      it 'should not update the action' do
        expect(action).not_to receive(:on_finish)

        subject
      end
    end
  end

  describe "#times_up?" do
    let(:finished_at) {1.hour.from_now}
    let(:action) { FactoryGirl.create :action, finished_at: finished_at }

    before do
      action.start!(time)
    end

    subject { action.times_up?(time) }

    context 'when finished_at before given time' do
      let(:time) { finished_at + 1.hour }

      it { should be_true }
    end

    context 'when finished_at after given time' do
      let(:time) { finished_at - 1.hour }

      it { should be_false }
    end
  end
end

