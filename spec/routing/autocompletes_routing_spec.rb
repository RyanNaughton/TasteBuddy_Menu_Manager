require "spec_helper"

describe AutocompletesController do
  describe "routing" do

    it "recognizes and generates #index" do
      { :get => "/autocompletes" }.should route_to(:controller => "autocompletes", :action => "index")
    end

    it "recognizes and generates #new" do
      { :get => "/autocompletes/new" }.should route_to(:controller => "autocompletes", :action => "new")
    end

    it "recognizes and generates #show" do
      { :get => "/autocompletes/1" }.should route_to(:controller => "autocompletes", :action => "show", :id => "1")
    end

    it "recognizes and generates #edit" do
      { :get => "/autocompletes/1/edit" }.should route_to(:controller => "autocompletes", :action => "edit", :id => "1")
    end

    it "recognizes and generates #create" do
      { :post => "/autocompletes" }.should route_to(:controller => "autocompletes", :action => "create")
    end

    it "recognizes and generates #update" do
      { :put => "/autocompletes/1" }.should route_to(:controller => "autocompletes", :action => "update", :id => "1")
    end

    it "recognizes and generates #destroy" do
      { :delete => "/autocompletes/1" }.should route_to(:controller => "autocompletes", :action => "destroy", :id => "1")
    end

  end
end
