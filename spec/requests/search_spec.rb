require 'spec_helper'

describe 'Search' do
  describe 'GET /search' do
    it 'succeeds' do
      get '/search'
      response.status.should be(200)
    end
  end
end
