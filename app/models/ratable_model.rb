module RatableModel
  def average_rating
    ratings.nil? || ratings.empty? and return nil
    average_value = ratings.values.inject(0) {|s,v| s + v.to_f } / ratings.size.to_f
    average_value.round(1)
  end

  PERMISSIBLE_RATINGS = (1..5).step(0.1).freeze

  def add_rating(user, rating)
    rating = rating.to_f
    self.ratings.nil? and self.ratings = {}
    user.ratings_count += process_rating(user, rating)
  end

  def user_rating(user)
    return nil if user.nil? or ! user.persisted?
    ratings[user.id.to_s]
  end  

  private

  def process_rating(user, rating)
    if ! PERMISSIBLE_RATINGS.include?(rating)
      errors.add(:ratings, "#{rating} is not a permitted value")
      0
    elsif user_rating(user)
      self.ratings[user.id.to_s] = rating
      0
    else
      self.ratings[user.id.to_s] = rating
      1
    end
  end
end
