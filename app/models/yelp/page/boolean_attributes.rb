module Yelp::Page::BooleanAttributes
  def reservations?
    doc.at('#bizAdditionalInfo').at('dd.attr-RestaurantsReservations').try(:content).try(:include?, 'Yes')
  end

  def takeout?
    doc.at('#bizAdditionalInfo').at('dd.attr-RestaurantsTakeOut').try(:content).try(:include?, 'Yes')
  end

  def delivery?
    doc.at('#bizAdditionalInfo').at('dd.attr-RestaurantsDelivery').try(:content).try(:include?, 'Yes')
  end

  def wheelchair_access?
    doc.at('#bizAdditionalInfo').at('dd.attr-WheelchairAccessible').try(:content).try(:include?, 'Yes')
  end
  
  def kid_friendly?
    doc.at('#bizAdditionalInfo').at('dd.attr-GoodForKids').try(:content).try(:include?, 'Yes')
  end

  def group_friendly?
    doc.at('#bizAdditionalInfo').at('dd.attr-RestaurantsGoodForGroups').try(:content).try(:include?, 'Yes')
  end

  def outdoor_seating?
    doc.at('#bizAdditionalInfo').at('dd.attr-OutdoorSeating').try(:content).try(:include?, 'Yes')
  end

  def credit_cards?
    doc.at('#bizAdditionalInfo').at('dd.attr-BusinessAcceptsCreditCards').try(:content).try(:include?, 'Yes')
  end  
end
