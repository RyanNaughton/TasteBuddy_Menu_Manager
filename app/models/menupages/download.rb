require 'csv'

module Menupages::Download
  extend self

  CSV_PATH = File.expand_path('../input/restaurants.csv', __FILE__)

  class RestaurantIteration
    attr_reader :path, :page, :restaurant

    def initialize(options)
      @page = Menupages::Page.new(options['menupages_url'] << '/menu')
      @restaurant = options['restaurant']
    end

    def data
      page.data(restaurant)
    end
  end

  def all
    CSV.foreach(CSV_PATH, :headers => true) do |row|
      next if row['yelp_url'].blank? || (r = Restaurant.where(yelp_url: row['yelp_url']).first).nil?
      RestaurantIteration.new(row.to_hash.merge(restaurant: r)).tap do |current|
        restaurant = Restaurant.where(yelp_url: row['yelp_url']).first
        restaurant.update_attribute(:menu, current.data)
      end
    end
  end
end
