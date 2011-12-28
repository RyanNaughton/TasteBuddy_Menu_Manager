require 'spec_helper'

describe Yelp::Import do
  describe '#one' do
    it 'loads data from one restaurant' do
      Yelp::Import.send(:one, 'http://www.yelp.com/biz/boka-chicago')
    end
  end
end
