require 'open-uri'

class Menupages::Node
  attr_reader :doc

  USER_AGENT = 'Mozilla/5.0 (X11; Linux x86_64; rv:2.0b9pre) Gecko/20110111 Firefox/4.0b9pre'.freeze
  DEFAULT_ENCODING = 'utf-8'.freeze

  def initialize(input)
    @doc = case input
      when Nokogiri::XML::Node
        input
      when File
        Nokogiri::HTML(input, nil, DEFAULT_ENCODING)
      when /\Ahttp/
        Nokogiri::HTML(open(input, 'User-Agent' => USER_AGENT), nil, DEFAULT_ENCODING)
      else
        Nokogiri::HTML(input)
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
