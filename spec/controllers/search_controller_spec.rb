require 'spec_helper'

describe SearchController do

  def mock_search(stubs={})
    @mock_search ||= mock_model(Search, stubs).as_null_object
  end

  describe 'GET new' do
    it 'assigns a new search as @search' do
      Search.stub(:new) { mock_search }
      get :new
      assigns(:search).should be(mock_search)
    end
  end

  describe 'POST show' do
    it 'assigns search parameters to @search' do
      Search.stub(:new).with({'these' => 'params'}) { mock_search(:save => false) }
      post :show, :search => {'these' => 'params'}
      assigns(:search).should be(mock_search)
    end
  end
end
