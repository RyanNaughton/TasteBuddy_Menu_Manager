require 'spec_helper'

describe 'Restaurants' do
  describe 'GET /restaurants' do
    before do
      Factory(:restaurant, :name => 'Trough')
      visit restaurants_path
    end

    it 'displays restaurants' do
      page.should have_content('Trough')
    end

    it 'does not display edit links' do
      page.should_not have_content('Edit')
    end

    it 'does not display destroy links' do
      page.should_not have_content('Destroy')
    end
  end
end
