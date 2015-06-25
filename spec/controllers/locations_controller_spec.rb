require 'spec_helper'

describe LocationsController do
  before { sign_in user }

  let(:game) { create :game, :with_setup }
  let(:user) { create :user }
  let(:location) { game.locations.first }

  let(:valid_attributes) { { game_id: game.id } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all locations as @locations" do
      get :index, {}, valid_session
      assigns(:locations).should include(location)
    end
  end

  describe "PUT update" do
    context 'when is not current location' do

      let(:current_location) { game.locations.last }

      before do
        current_location.update_attributes!(is_current: false)
      end

      context "when not setting current to true" do
        it "skips updates" do
          Location.any_instance.should_not_receive(:spawn_pcs_together)

          put :update, {:id => location.to_param, :location => valid_attributes.merge({'is_current' => 'false'})}, format: :json

          expect(location.reload.is_current).to be_falsey
        end
      end

      it "updates the is current attr" do
        Location.any_instance.should_receive(:spawn_pcs_together)

        put :update, {:id => location.to_param, :location => valid_attributes.merge({'is_current' => 'true'})}, format: :json

        expect(location.reload.is_current).to be_truthy
        expect(current_location.reload.is_current).to be_falsey
      end

      it "assigns the location" do
        put :update, {:id => location.to_param, :location => valid_attributes.merge({'is_current' => 'true'})}, format: :json

        assigns(:location).should be_a(Location)
      end
    end
  end
end

