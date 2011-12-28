class Restaurant::Neighborhood
  include Mongoid::Document
  include Sunspot::Mongoid

  field :name
  validates_presence_of :name
  field :designation, :default => 'neighborhood'

  searchable(:auto_index => true) do
    text :name
  end

  def self.autocomplete_search(query, coordinates=nil, options={})
    options = {:page => 1}.merge(options)
    self.solr_search {
      keywords(query)
      paginate :page => options[:page], :per_page => 100
    }.results.map(&:name).uniq
  end
end
