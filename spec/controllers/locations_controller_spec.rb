require 'spec_helper'

describe LocationsController do
  before { sign_in user }

  let(:game) { FactoryGirl.create :game }
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
        current_location.update_attributes!(is_current: true)
      end

      it "updates the is current attr" do
        put :update, {:id => location.to_param, :location => valid_attributes.merge({'is_current' => 'true'})}, format: :json

        expect(location.reload.is_current).to be_true
        expect(current_location.reload.is_current).to be_false
      end

      it "assigns the location" do
        put :update, {:id => location.to_param, :location => valid_attributes.merge({'is_current' => 'true'})}, format: :json

        assigns(:location).should be_a(Location)
      end
    end
  end
end

