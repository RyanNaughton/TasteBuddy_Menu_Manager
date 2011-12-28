class Restaurant
  include Mongoid::Document
  include Mongoid::Timestamps
  include RatableModel
  include TaggableModel
  include BookmarkableModel
  extend Mongoid::Geo::Near
  extend Geolocation
  include MenuQueries
  include Sunspot::Mongoid

  searchable(:auto_index => true) do
    text :name, :boost => 5.0
    text :cuisine_types, :boost => 2.0
    text :menu_item_name do
      MenuItem.where(restaurant_id: self.public_send(:id)).all.map(&:name)
    end
    boolean :has_menu do
      menu.present?
    end
    location :coordinates do
      Sunspot::Util::Coordinates.new(latitude, longitude)
    end
  end

  CHICAGO = [41.881944, -87.627778].freeze

  def self.search(query, coordinates=CHICAGO, options={})
    options = {:page => 1}.merge(options)
    self.solr_search {
      keywords(query)
      paginate :page => options[:page]
    }.results
    .each do |result|
      result.distance_to(coordinates)
      # result.menu_items = MenuItem.restaurant_items_search(query, result.id).tap do |dishes|
      #   dish_names = dishes.map(&:name).uniq
      #   tem = dishes.dup
      #   dishes.each do |dish|
      #     tem -= [dish] if ! dish_names.include?(dish.name)
      #     dish_names -= [dish.name]
      #   end
      #   dishes = tem
      # end

      dishes = MenuItem.restaurant_items_search(query, result.id)
      dish_names = dishes.map(&:name).uniq
      tem = dishes.dup
      dishes.each do |dish|
        tem -= [dish] if ! dish_names.include?(dish.name)
        dish_names -= [dish.name]
      end
      result.menu_items = tem

      # MenuItem.search(query.to_s.dup << %q{ } << result.id.to_s).results 
    end
  end

  def self.autocomplete_search(query, coordinates=CHICAGO, options={})
    options = {:page => 1}.merge(options)
    self.solr_search {
      keywords(query)
      paginate :page => options[:page], :per_page => 100
    }.results.map(&:name).uniq
  end

  attr_reader :distance

  def distance_to(coordinates)
    Haversine
      .distance(latitude.to_f, longitude.to_f, *coordinates)[:miles]
      .number
      .tap {|number| @distance = number.round(2) }
  end

  attr_accessor :menu_items, :distance

  has_many :pictures
  embeds_many :comments, :as => :commentable

  scope :all_by_name, order_by(:name.asc)

  field :menu, :type => Array
  field :tags, :type => Hash, :default => {}

  field :yelp_id
  validates_uniqueness_of :yelp_id, :allow_blank => true

  field :yelp_url
  validates_uniqueness_of :yelp_url, :allow_blank => true

  field :name
  validates_length_of :name, :in => 2..255, :allow_blank => false

  field :cuisine_types, :type => Array

  field :brief_description
  validates_length_of :brief_description, :maximum => 255, :allow_blank => true

  field :full_description
  validates_length_of :full_description, :maximum => 2000, :allow_blank => true

  field :address_1
  validates_length_of :address_1, :in => 2..120, :allow_blank => false

  field :address_2
  validates_length_of :address_2, :in => 2..120, :allow_blank => true

  field :city_town
  validates_length_of :city_town, :in => 2..50, :allow_blank => false

  field :neighborhood
  validates_length_of :neighborhood, :in => 2..50, :allow_blank => true

  field :state_province
  validates_length_of :state_province, :minimum => 2, :maximum => 2, :allow_blank => false

  field :postal_code
  validates_length_of :state_province, :maximum => 30, :allow_blank => true

  field :country, :default => 'US'
  validates_length_of :country, :minimum => 2, :maximum => 2, :allow_blank => false

  field :phone
  validates_length_of :phone, :minimum => 7, :maximum => 40, :allow_blank => true

  field :fax
  validates_length_of :fax, :minimum => 7, :maximum => 40, :allow_blank => true

  field :website_url
  validates_length_of :website_url, :maximum => 120, :allow_blank => true
  validates_format_of :website_url, :with => %r{\Ahttp://}, :allow_blank => true

  field :dress_code
  validates_inclusion_of :dress_code, :in => %w{none casual business-casual business}, :allow_blank => true

  field :credit_cards, :type => Boolean
  field :reservations, :type => Boolean
  field :takeout, :type => Boolean
  field :delivery, :type => Boolean
  field :delivery_minimum, :type => Integer
  field :delivery_fee, :type => Float
  field :delivery_details
  field :delivery_radius
  field :wheelchair_access, :type => Boolean
  field :group_friendly, :type => Boolean
  field :kid_friendly, :type => Boolean
  field :outdoor_seating, :type => Boolean
  field :byob, :type => Boolean
  field :alcohol_type
  field :live_music, :type => Boolean
  field :live_music_details
  validates_presence_of :live_music_details, :if => proc {|obj| obj.live_music }
  field :jukebox, :type => Boolean
  field :parking
  field :parking_details
  field :smoking, :type => Boolean
  field :wifi, :type => Boolean
  field :nearest_transit
  field :additional_details
  field :latitude, :type => Float
  field :longitude, :type => Float

  def location
    return nil if [latitude, longitude].any?(&:blank?)
    [latitude, longitude].map(&:to_f)
  end

  def location=(array)
    self.latitude, self.longitude = array
  end

  field :survey, :type => Boolean
  field :ratings, :type => Hash, :default => {}
  field :bookmarks, :type => Array, :default => []
  field :hours, :type => Array, :default => [[{open: {h: 11, m: 30}, close: {h: 2, m: 0}}, {open: {h: 5, m: 30}, close: {h: 10, m: 30}}], [{open: {h: 11, m: 30}, close: {h: 2, m: 0}}, {open: {h: 5, m: 30}, close: {h: 10, m: 30}}],[{open: {h: 11, m: 30}, close: {h: 2, m: 0}}, {open: {h: 5, m: 30}, close: {h: 10, m: 30}}],[{open: {h: 11, m: 30}, close: {h: 2, m: 0}}, {open: {h: 5, m: 30}, close: {h: 10, m: 30}}],[{open: {h: 11, m: 30}, close: {h: 2, m: 0}}, {open: {h: 5, m: 30}, close: {h: 10, m: 30}}],[{open: {h: 5, m: 30}, close: {h: 11, m: 30}}],[{open: {h: 5, m: 30}, close: {h: 11, m: 30}}]]

  def ratings_count
    ratings.keys.size
  end

  def average_meal_price
    while true
      val = (35 * rand).round(2)
      return val if val >= 12
    end
  end

  def application_hash(user=nil)
    values_to_delete = %w{_id _keywords arrangeable_values searchable_values created_at updated_at yelp_id yelp_url latitude longitude menu ratings survey bookmarks}
    values = attributes
    if user
      values['user_rating'] = ratings[user.id.to_s]
      values['user_tags'] = user_tags(user)
      values['bookmark'] = bookmarks.include?(user.id)
    end
    if menu_items
      values['menu_items'] = menu_items.map {|obj| obj.application_hash(user) }
    end
    if distance
      values['distance'] = distance
    end
    values['pictures'] = pictures.map {|p| p.application_hash(user)}
    values['tags'] = tags_with_count
    values['id'] = values['_id']
    values['average_meal_price'] = average_meal_price
    values['average_rating'] = average_rating
    values['ratings_count'] = ratings_count
    values['comments'] = comments
    values['menu_metadata'] = menu_metadata
    values['location'] = location
    values_to_delete.each {|v| values.delete(v) }
    values
  end
end
