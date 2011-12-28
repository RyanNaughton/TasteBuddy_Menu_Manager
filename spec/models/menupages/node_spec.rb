RIGHT_SINGLE_QUOTATION_MARK = "\u2019".freeze
BROKEN_CHARACTER_SEQUENCE = "\u00E2\u0080\u0099"

describe Menupages::Node do
  before(:each) do
    @path = File.dirname(__FILE__) << '/test_data/character_tag.html'
  end

  describe 'character encoding' do
    it 'fails under Nokogiri defaults' do
      File.open(@path, 'r') do |f|
        Nokogiri::HTML(f)
          .at('h3')
          .content
          .should eq "Dealer#{BROKEN_CHARACTER_SEQUENCE}s Choice"
      end
    end

    it 'is explicitly set to UTF-8' do
      File.open(@path, 'r') do |f|
        Menupages::Node.new(f).doc.content.should eq "Dealer#{RIGHT_SINGLE_QUOTATION_MARK}s Choice"
      end
    end
  end
end
