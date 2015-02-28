require "spec_helper"

describe BuildingsController do
  describe "routing" do

    it "routes to #index" do
      get("/buildings").should route_to("buildings#index")
    end

    it "routes to #new" do
      get("/buildings/new").should route_to("buildings#new")
    end

    it "routes to #show" do
      get("/buildings/1").should route_to("buildings#show", :id => "1")
    end

    it "routes to #edit" do
      get("/buildings/1/edit").should route_to("buildings#edit", :id => "1")
    end

    it "routes to #create" do
      post("/buildings").should route_to("buildings#create")
    end

    it "routes to #update" do
      put("/buildings/1").should route_to("buildings#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/buildings/1").should route_to("buildings#destroy", :id => "1")
    end

  end
end
