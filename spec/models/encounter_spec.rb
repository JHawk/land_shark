require 'spec_helper'

describe Encounter do
  it { should have_many(:npcs) }
  it { should belong_to(:location) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:location) }

  describe '.generate_at!' do
    let(:location) { FactoryGirl.create :location }
    let(:game) { double(:game, time: Time.now)}

    before do
      location.should_receive(:game).and_return(game)
    end

    subject { Encounter.generate_at!(location) }

    it { subject.reload.location_id.should eq(location.id) }
    it { subject.reload.npcs.should_not be_empty }
  end

  describe '#check_complete!' do
    let(:encounter) { FactoryGirl.create :encounter }

    subject { encounter.check_complete! }

    context 'when no npcs' do
      it { should be_falsey }

      it 'does not update the encounter' do
        subject

        expect(encounter.reload.completed?).to be_falsey
      end
    end

    context 'when npcs' do
      let(:character) { FactoryGirl.create :character, is_dead: is_dead }

      before do
        encounter.npcs << character
      end

      context 'when npcs are not all dead' do
        let(:is_dead) { false }

        it { should be_falsey }

        it 'does update the encounter' do
          subject

          expect(encounter.reload.completed?).to be_falsey
        end
      end

      context 'when npcs are all dead' do
        let(:is_dead) { true }

        it { should be_truthy }

        it 'does update the encounter' do
          subject

          expect(encounter.reload.completed?).to be_truthy
        end
      end
    end
  end
end

