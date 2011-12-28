require 'spec_helper'

describe Menupages::Page do
  context 'Boka (Chicago)' do
    describe 'from disk cache' do
      before(:all) do
        path = File.dirname(__FILE__) << '/test_data/boka.menu.html'
        file = File.open(path, 'r')
        @page = Menupages::Page.new(IO.read(file))
        @expected_data = YAML::load_file(File.dirname(__FILE__) << '/test_data/boka.menu.yaml')
      end

      it 'matches' do
        @page.data.should eq @expected_data
      end

      it 'gets the restaurant identifier' do
        @page.menupages_identifier == 'Boka-9342'
      end
    end

    describe 'from network' do
      before(:all) do
        @page = Menupages::Page.new('http://chicago.menupages.com/restaurants/boka/menu')
        @expected_data = YAML::load_file(File.dirname(__FILE__) << '/test_data/boka.menu.yaml')
      end

      it 'matches' do
        @page.data.should eq @expected_data
      end
    end
  end

  context "Ribs 'N' Bibs (Chicago)" do
    describe 'from disk cache' do
      before(:all) do
        path = File.dirname(__FILE__) << '/test_data/ribsnbibs.menu.html'
        file = File.open(path, 'r')
        @page = Menupages::Page.new(Nokogiri::HTML(file))
      end

      describe '#data' do
        it 'raises no exception' do
          proc { @page.data }.should_not raise_error
        end
      end
    end
  end

  context 'Medici (Chicago)' do
    describe 'from disk cache' do
      before(:all) do
        path = File.dirname(__FILE__) << '/test_data/medici.menu.html'
        file = File.open(path, 'r')
        @page = Menupages::Page.new(Nokogiri::HTML(file))
      end

      describe '#data' do
        it 'raises no exception' do
          proc { @page.data }.should_not raise_error
        end
      end
    end

    describe 'from network' do
      before(:all) do
        @page = Menupages::Page.new('http://chicago.menupages.com/restaurants/medici/menu')
      end

      describe '#data' do
        it 'raises no exception' do
          proc { @page.data }.should_not raise_error
        end
      end
    end
  end
end
