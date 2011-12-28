class Yelp::Page < Yelp::Node
  include BooleanAttributes
  include SubjectiveAttributes

  attr_reader :doc

  def data
    {
      :name => name,
      :cuisine_types => [cuisine_type],
      :website_url => website_url,
      :phone => phone,
      :yelp_id => yelp_id,
      :alcohol_type => alcohol_type,
      :dress_code => dress_code,
      :parking => parking,
      :credit_cards => credit_cards?,
      :reservations => reservations?,
      :takeout => takeout?,
      :delivery => delivery?,
      :wheelchair_access => wheelchair_access?,
      :kid_friendly => kid_friendly?,
      :group_friendly => group_friendly?,
      :outdoor_seating => outdoor_seating?,
      :nearest_transit => nearest_transit,
      :location => coordinates,
    }
      .merge(location_info)
  end

  module BasicAttributes
    def yelp_id
      yelp_url = doc
        .at('head')
        .search('meta')
        .detect {|n| n['property'] == 'og:url'}['content']
      yelp_url.split('/').last
    end

    def name
      doc
        .at('head')
        .search('meta')
        .detect {|n| n['property'] == 'og:title'}['content']
    end

    def phone
      doc.at('#bizPhone.tel').content
    end

    def website_url
      return if ! (link = doc.at('#bizUrl a'))
      if link['href'] =~ %r{http[:]//www[.]yelp[.]com/biz_redir[?]url[=](.*?)[&]src_bizid[=]}
        Regexp.last_match.captures.first.gsub(/%2F/, '/').sub('%3A', ':')
      end
    end

    private

    def title
      doc.at('title').content
    end
  end

  include BasicAttributes

  module GeographicAttributes
    def location_info
      Address.new(doc.at('address')).data
    end

    def coordinates
      [latitude, longitude].map do |value|
        value.to_f.zero? ? nil : value.to_f
      end
    end

    def latitude
      doc
        .at('head')
        .search('meta')
        .detect {|n| n['property'] == 'og:latitude'}['content']
    end

    def longitude
      doc
        .at('head')
        .search('meta')
        .detect {|n| n['property'] == 'og:longitude'}['content']
    end
  end

  include GeographicAttributes
end
