require 'spec_helper'

describe Restaurant do
  describe '.search' do
    describe 'by keyword' do
      before(:each) do
        @silver_spoon, @hyde_park, @river_north = [:silver_spoon, :hyde_park, :river_north].map {|sym| Factory(sym) }
        Sunspot.commit
      end

      after(:all) do
        Sunspot.commit
      end

      context 'a name without whitespace' do
        it 'is matched' do
          Restaurant.search('quartino').to_a.should eq [@river_north]
        end
      end

      context 'a name with whitespace' do
        it 'is not matched' do
          Restaurant.search('Silver Spoon').to_a.should eq [@silver_spoon]
        end
      end

      context 'a cuisine type' do
        it 'is matched' do
          Restaurant.search('Thai').to_a.should eq [@silver_spoon]
        end
      end

      context 'a name substring' do
        it 'is included' do
          Restaurant.search('Silver').to_a.should eq [@silver_spoon]
          Restaurant.search( 'Spoon').to_a.should eq [@silver_spoon]
        end
      end

      context 'a partial word match' do
        it 'is not included' do
          Restaurant.search('Tha').to_a.should be_empty
        end
      end
    end

    describe 'by location' do
      before(:each) do
        [:silver_spoon, :hyde_park, :river_north].each {|sym| Factory(sym) }
        Sunspot.commit
      end

      after(:all) do
        Sunspot.commit
      end

      context 'a location from outside the geohash zone' do
        it 'is not matched' do
          Restaurant.search(String.new, [40.716667, -74]).to_a.should be_empty # New York City
        end
      end

      context 'a location inside the geohash zone' do
        it 'is matched' do
          Restaurant.search(String.new, [41.8, -87.59]).to_a.should_not be_empty # Hyde Park
        end
      end
    end
  end
end
