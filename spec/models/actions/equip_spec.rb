require 'spec_helper'

describe Actions::Equip do
  let(:character) { FactoryGirl.create :character, x:0, y:0, z:1 }

  let(:action) { Actions::Equip.create! character: character }

  let(:time) { Time.zone.now }

  describe "#start!" do
    subject { action.start!(time) }

    it 'sets the finished_at' do
      subject

      expect(action.reload.started_at.to_i).to eq(time.to_i)
      expect(action.reload.finished_at.to_i).to eq((time + 2).to_i)
    end
  end

  describe "#on_finish" do
    subject { action.on_finish }

    it 'equips' do
      expect(character).to receive(:equip!)

      subject
    end
  end

  describe "#ticking" do
    it 'equips' do
      expect(character).to receive(:equip!)

      action.start! time

      10.times do
        action.tick(time + 10.minutes)
      end
    end
  end
end

