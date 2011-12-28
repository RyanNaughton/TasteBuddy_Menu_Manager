module RestaurantHelper
  ALCOHOL_TYPES = ['Full Bar', 'Beer & Wine', 'Wine Only', 'Beer Only', 'None'].freeze
  DRESS_CODES = %w{none casual business-casual business}.freeze
  PARKING_TYPES = %w{street lot valet}.freeze

  def alcohol_types
    ALCOHOL_TYPES
  end

  def dress_codes
    DRESS_CODES
  end

  def parking_types
    PARKING_TYPES
  end

  def neighborhoods
    Restaurant::Neighborhood.all.map(&:name)
  end

  def cuisine_types
    Restaurant::CuisineTypeOption.all.map(&:name)
  end

  def setup_restaurant(restaurant)
    restaurant
  end

  def humanize_bool(input)
    input.nil? and return nil
    input ? 'yes' : 'no'
  end
end
