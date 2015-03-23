require 'spec_helper'

describe Actions::Throw do
  let(:character) { FactoryGirl.create :character, x:0, y:0, z:1, land_speed: 1, path: "[[0,0,1],[1,1,1],[2,2,2]]" }
  let(:action) { Actions::Throw.create! character: character }
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
    subject { action.delivery }

    context 'when character has a target character' do
      let(:target) { FactoryGirl.create :character }

      before do
        character.update_attributes!(target_character_id: target.id)
      end

      context 'when character has an item equipped' do
        let(:item) { FactoryGirl.create :item }

        before do
          character.items << item
          character.update_attributes!(equipped_item_id: item.id)
        end

        it 'should remove the item from the characters items' do
          expect(character.reload.items).to include(item)

          subject

          expect(character.reload.items).to_not include(item)
          expect(character.reload.equipped_item_id).to be_nil
        end

        it 'should damage the target' do
          prior_hit_points = target.hit_points

          subject

          expect(target.reload.hit_points).to be < prior_hit_points
        end
      end
    end
  end
end

