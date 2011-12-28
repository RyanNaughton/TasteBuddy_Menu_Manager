require 'spec_helper'

describe Yelp::Page do
  before(:all) do
    @page = Yelp::Page.new('http://www.yelp.com/biz/boka-chicago')
  end

  describe 'parsing' do
    context 'top priority data points' do

      it 'gets the phone number' do
        @page.phone.should eq '(312) 337-6070'
      end

      it 'gets the latitude and longitude' do
        @page.coordinates.should eq [41.9128990173, -87.6483001709]
      end

      it 'captures the name' do
        @page.name.should eq 'Boka'
      end

      it 'captures the url' do
        @page.website_url.should eq('http://www.bokachicago.com')
      end

      it 'captures the address data' do
        @page.location_info.should eq(
          address_1: '1729 N Halsted St',
          address_2: '(between Concord Pl & Willow St)',
          city_town: 'Chicago', state_province: 'IL', postal_code: '60614',
          :neighborhood => "Lincoln Park"
        )
      end

      it 'captures the cuisine type' do
        @page.cuisine_type.should eq 'American (New)'
      end
    end

    context 'less important items' do
      it 'captures the yelp id' do
        @page.yelp_id.should eq 'XKUZV9O2sRFLDIpAmwmG5g'
      end

      it 'gets the title' do
        @page.send(:title).should eq 'Boka - Lincoln Park - Chicago, IL'
      end

      it 'gets parking info' do
        @page.parking.should eq 'Valet'
      end

      it 'checks for credit cards' do
        @page.credit_cards?.should be_true
      end
    end
  end
end
