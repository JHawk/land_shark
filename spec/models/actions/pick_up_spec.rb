require 'spec_helper'

describe Actions::PickUp do
  let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1, path: "[[0,0,1],[1,1,1],[2,2,2]]" }
  let(:action) { Actions::PickUp.create! character: character }
  let(:time) { Time.zone.now }

  describe "#start!" do
    subject { action.start!(time) }

    it 'sets the finished_at' do
      subject

      expect(action.reload.started_at.to_i).to eq(time.to_i)
      expect(action.reload.finished_at.to_i).to eq((time + 2).to_i)
    end
  end

  describe "#delivery" do
    let(:location) { FactoryGirl.create :location }

    subject { action.delivery }

    before do
      character.update_attributes!(location_id: location.id)
    end

    context 'when character has a target item' do
      let(:target) { FactoryGirl.create :item, x:9, y:8, z:7 }

      before do
        character.update_attributes!(target_item_id: target.id)
      end

      it 'adds the item to the character inventory' do
        subject

        expect(character.reload.items).to include(target)
      end
    end
  end
end

