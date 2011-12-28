describe Menupages::Row do
  context 'of menu items' do
    before(:each) do
      path = File.dirname(__FILE__) << '/test_data/tr.html'
      file = File.open(path, 'r')
      @row = Menupages::Row.new(Nokogiri::HTML(file).at('tr'))
    end

    describe '#description_only?' do
      it 'returns false' do
        @row.description_only?.should be_false
      end
    end

    describe '#data' do
      it 'returns structured item' do
        @row.data.should eq(
          name: 'Grand Tasting Menu',
          description: 'sampling of chefs favorite dishes',
          prices: [115.0],
        )
      end
    end
  end

  context 'of description' do
    before(:each) do
      path = File.dirname(__FILE__) << '/test_data/tr_extra.html'
      file = File.open(path, 'r')
      @row = Menupages::Row.new(Nokogiri::HTML(file).at('tr'))
    end

    describe '#description_only?' do
      it 'returns true' do
        @row.description_only?.should be_true
      end
    end

    describe '#data' do
      it 'returns structured item' do
        @row.data.should eq(description: 'All Guests At A Table Must Partake In The Tasting Menu. Receive 20 % Off Of The Reserve Wine List When You Enjoy Either The 6-Course Degustation Or Grand Tasting Menu.')
      end
    end
  end
end
