class MenuItem
  include Mongoid::Document
  include RatableModel
  include TaggableModel
  include BookmarkableModel

  belongs_to :restaurant
  has_many :pictures
  embeds_many :comments, :as => :commentable

  field :name
  field :description
  field :prices, :type => Array, :default => []
  field :survey, :type => Boolean
  field :ratings, :type => Hash, :default => {}
  field :tags, :type => Hash, :default => {}
  field :bookmarks, :type => Array, :default => []
  field :rest

  include Sunspot::Mongoid

  searchable(:auto_index => true) do
    text :name, :boost => 2.0
    text :rest
    string :restaurant_id
  end

  def self.restaurant_items_search(query, search_restaurant_id)
    # options = {:page => 1}.merge(options={})
    # self.solr_search {
    #   with(:restaurant_id, search_restaurant_id.to_s)
    #   keywords(query) {minimum_match 0}
    # }
    options = {:page => 1}.merge(options={})
    self.solr_search {
      keywords(query) {minimum_match 0}
    }.results.select {|r| r.restaurant_id == search_restaurant_id}
  end

  def self.search(query)
    options = {:page => 1}.merge(options={})
    self.solr_search {
      keywords(query)
    }
  end

  def latitude
    restaurant.try(:latitude)
  end

  def longitude
    restaurant.try(:longitude)
  end

  def self.autocomplete_search(query, coordinates=[41.881944, -87.627778], options={})
    options = {:page => 1}.merge(options)
    self.solr_search {
      keywords(query)
      paginate :page => options[:page], :per_page => 100
    }.results.map(&:name).uniq
  end

  def ratings_count
    ratings.keys.size
  end

  def random_price
    (29 * rand).round(2)
  end

  def application_hash(user=nil)
    values_to_delete = %w{_id _keywords arrangeable_values searchable_values created_at updated_at ratings options description prices survey bookmarks}
    values = attributes
    if user
      values['user_rating'] = ratings[user.id.to_s]
      values['user_tags'] = user_tags(user)
      values['bookmark'] = bookmarks.include?(user.id)
    end
    values['pictures'] = pictures.map {|p| p.application_hash(user)}
    values['id'] = values['_id']
    values['restaurant_id'] = restaurant_id
    values['average_rating'] = average_rating
    values['ratings_count'] = ratings_count
    values['comments'] = comments
    values['tags'] = tags_with_count
    values['price'] = prices.first or random_price
    values_to_delete.each {|v| values.delete(v) }
    values
  end
end
