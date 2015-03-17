require 'spec_helper'

describe LocationsController do
  let(:user) { create :user }

  before { sign_in user }

  let(:valid_attributes) { {  } }

  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all locations as @locations" do
      location = Locations::Hospital.create! valid_attributes
      get :index, {}, valid_session
      assigns(:locations).should eq([location])
    end
  end
end

