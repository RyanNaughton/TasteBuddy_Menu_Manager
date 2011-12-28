class Search
  include Mongoid::Document
  include Geokit::Geocoders
  belongs_to :user

  field :find, :type => String
  field :near, :type => String
  field :coordinates, :type => Array
  field :page, :type => Integer

  CHICAGO_COORDINATES = [41.881944, -87.627778].freeze

  def results(options={})
    self.coordinates = CHICAGO_COORDINATES.dup if coordinates.blank?
    Restaurant.search(find, location, options)
  end

  CURRENT_LOCATION_REGEXP = /current\s*location/i

  def location
    return coordinates if coordinates.present? and (near.blank? or near.match(CURRENT_LOCATION_REGEXP))
    return CHICAGO_COORDINATES if near.blank?
    lookup_coordinates
  end

  def autocomplete(options={})
    self.coordinates = CHICAGO_COORDINATES.dup if coordinates.blank?
    { restaurants: Restaurant.autocomplete_search(find, location, options),
      menu_items: MenuItem.autocomplete_search(find, location, options),
      neighborhoods: Restaurant::Neighborhood.autocomplete_search(near.to_s.sub(CURRENT_LOCATION_REGEXP, ''), location, options) }
  end

  private

  def lookup_coordinates
    geocoder_str = case near
      when /chicago/i
        near
      else
        near + %q{ Chicago}
    end

    MultiGeocoder
      .geocode(geocoder_str)
      .ll
      .split(',')
      .map(&:to_f)
  end
end
