module Yelp::Import
  def self.all
    url_list
      .each {|url| Restaurant.where(yelp_url: url).count.zero? and one(url) }
      .size
  end

  def self.one(url)
    info = Yelp::Page.new(url).data.merge(yelp_url: url)
    Restaurant.create!(info)
  end

  private

  DATA_PATH = (File.dirname(__FILE__) << '/input/url_list.txt').freeze

  def self.url_list
    File.open(DATA_PATH).map(&:chomp)
  end
end
