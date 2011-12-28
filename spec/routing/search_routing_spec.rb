require 'spec_helper'

describe SearchController do
  describe 'routing' do

    it 'recognizes and generates #new' do
      { :get => '/search' }.should route_to(:controller => 'search', :action => 'new')
    end

    it 'recognizes and generates #show' do
      { :post => '/search' }.should route_to(:controller => 'search', :action => 'show')
    end
  end
end
