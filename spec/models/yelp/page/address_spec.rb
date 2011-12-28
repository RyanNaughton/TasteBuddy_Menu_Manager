require 'spec_helper'

describe Yelp::Page::Address do
  context 'Boka in Chicago' do
    before(:each) do
      path = File.dirname(__FILE__) << '/../test_data/boka.address.html'
      file = File.open(path, 'r')
      @address = Yelp::Page::Address.new(Nokogiri::HTML(file).at('address'))
    end

    BOKA_DATA = { 
      address_1: '1729 N Halsted St',
      address_2: '(between Concord Pl & Willow St)',
      city_town: 'Chicago', state_province: 'IL', postal_code: '60614',
      neighborhood: 'Lincoln Park'
    }.each_pair {|key, value|

      it "##{key} should match #{value}" do
        @address.send(key).should eq value
      end

    }

    describe '#data' do
      it 'returns the data' do
        @address.data.should eq BOKA_DATA
      end
    end
  end
end
