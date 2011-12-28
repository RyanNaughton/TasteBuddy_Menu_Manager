require_dependency File.expand_path('../../restaurant', __FILE__)

class Restaurant
  module Geolocation

    # Ellipsoid approximations -- equatorial latitude
    CONVERSION_FACTORS = {
      :degrees    =>   1,
      :miles      =>  68.7,
      :kilometers => 110.57,
    }.freeze

    def by_proximity(point, distance, type = :degrees)
      near_max = Struct.new(:point, :distance).new.tap do |obj|
        obj.point = point
        obj.distance = distance / CONVERSION_FACTORS[type.to_sym]
      end

      where(:location.nearMax => near_max)
    end
  end
end
