module RatableHelper
  EMDASH = "\u2014".freeze

  def emdash
    EMDASH
  end

  def format_rating(str)
    str.blank? ? EMDASH : str
  end
end
