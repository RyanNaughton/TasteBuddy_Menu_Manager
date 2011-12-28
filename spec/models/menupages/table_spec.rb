describe Menupages::Table do
  context 'of menu items' do
    before(:each) do
      path = File.dirname(__FILE__) << '/test_data/boka.table.html'
      file = File.open(path, 'r')
      @table = Menupages::Table.new(file)
    end

    describe '#data' do
      it 'returns structured items' do
        @table.data.should eq [
          {name: '4-Course Degustation Menu', prices: [65.0]},
          {name: '6-Course Degustation Menu', prices: [85.0]},
          {name: 'Grand Tasting Menu', description: 'sampling of chefs favorite dishes', prices: [115.0]},
          {description: 'All Guests At A Table Must Partake In The Tasting Menu. Receive 20 % Off Of The Reserve Wine List When You Enjoy Either The 6-Course Degustation Or Grand Tasting Menu.'}
        ]
      end
    end
  end
end
