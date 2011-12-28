class Yelp::Page::Address < Yelp::Node
  def data
    {
      address_1: address_1,
      address_2: address_2,
      city_town: city_town,
      state_province: state_province,
      postal_code: postal_code,
      neighborhood: neighborhood,
    }
  end

  private

  def address_1
    doc.at('.street-address').content
  end

  def address_2
    begin
      doc
        .children
        .detect {|n| n.content.include?('between ')}
        .content
        .strip
    rescue
      nil
    end
  end

  def city_town
    doc.at('.locality').content
  end

  def state_province
    doc.at('.region').content    
  end

  def postal_code
    doc.at('.postal-code').content
  end

  def neighborhood
    begin
      doc
        .children[-2]
        .inner_text
        .match(/Neighborhood[s]?:\s(.*\z)/)
        .captures
        .first
    rescue
      nil
    end
  end
end
