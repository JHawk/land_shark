require 'spec_helper'

describe Action do
  it { should belong_to(:character) }

  it { should validate_presence_of(:started_at) }
  it { should validate_presence_of(:character) }

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

  describe "#finished?" do
    let(:finished_at) {1.hour.from_now}
    let(:action) { FactoryGirl.create :action, finished_at: finished_at }

    subject { action.finished?(time) }

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

