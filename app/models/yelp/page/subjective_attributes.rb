module Yelp::Page::SubjectiveAttributes
  def cuisine_type
    doc.at('#cat_display').at('a').content
  end

  def alcohol_type
    doc.at('#bizAdditionalInfo').at('dd.attr-Alcohol').try(:content)
  end

  def dress_code
    kind = doc.at('#bizAdditionalInfo').at('dd.attr-RestaurantsAttire').try(:content)
    case kind
      when 'Dressy'
        'business'
      when 'Casual'
        'casual'
      else
        'none'
    end
  end

  def parking
    doc.at('#bizAdditionalInfo').at('dd.attr-BusinessParking').try(:content).try(:strip)
  end

  def nearest_transit
    doc.at('#bizAdditionalInfo').at('dd.attr-transit').try(:content).try(:strip)
  end
end
