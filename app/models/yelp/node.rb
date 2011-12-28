require 'open-uri'

class Yelp::Node
  attr_reader :doc

  def initialize(input)
    @doc = case input
      when Nokogiri::XML::Node
        input
      when File
        Nokogiri::HTML(input)
      else
        Nokogiri::HTML(open(input))
    end
  end

  private

  def empty_str
    %q{}
  end

  def non_blocking_space
    "\u00A0"
  end
end
