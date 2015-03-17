require "spec_helper"

describe OccupationsController do
  describe "routing" do

    it "routes to #index" do
      get("/occupations").should route_to("occupations#index")
    end

    it "routes to #new" do
      get("/occupations/new").should route_to("occupations#new")
    end

    it "routes to #show" do
      get("/occupations/1").should route_to("occupations#show", :id => "1")
    end

    it "routes to #edit" do
      get("/occupations/1/edit").should route_to("occupations#edit", :id => "1")
    end

    it "routes to #create" do
      post("/occupations").should route_to("occupations#create")
    end

    it "routes to #update" do
      put("/occupations/1").should route_to("occupations#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/occupations/1").should route_to("occupations#destroy", :id => "1")
    end

  end
end
