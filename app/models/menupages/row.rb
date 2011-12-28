class Menupages::Row < Menupages::Node
  def data(restaurant)
    if description_only?
      return { description: category_description }
    end

    attributes = { name: name, prices: prices }.merge(item_description)
    menu_item = MenuItem.create!(attributes)
    {menu_item_id: menu_item.id}
  end

  def name
    doc.at('cite').content
  end

  def description_only?
    !! doc.attributes['class']
  end

  private

  def category_description
    doc.at('cite').content
  end

  def has_item_description?
    ! item_description_string.empty?
  end

  def item_description
    return {} if ! has_item_description?
    { description: item_description_string }
  end

  def item_description_string
    doc.at('th').content.sub(category_description, empty_str).gsub(non_blocking_space, empty_str).strip
  end

  def prices
    doc
      .search('td')
      .map(&:content)
      .map {|str| str.sub(non_blocking_space, empty_str) }
      .reject {|str| str.to_f.zero? }
      .map(&:to_f)
  end
end
