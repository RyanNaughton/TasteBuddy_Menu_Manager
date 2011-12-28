describe Menupages::RowOption do
  context 'with a price' do
    before(:each) do
      path = File.dirname(__FILE__) << '/test_data/tr_sub.html'
      file = File.open(path, 'r')
      @row = Menupages::RowOption.new(Nokogiri::HTML(file).at('tr'))
    end

    describe '#data' do
      it 'returns structured item' do
        @row.data.should eq(name: 'add shrimp', prices: [65.95])
      end
    end
  end
end
