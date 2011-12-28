module Restaurant::MenuQueries
  def menu_metadata
    menu.blank? and return []
    menu
      .select {|o| o['subcategories'].any? {|s| ! s.empty? } }
      .map { |o| o.fetch('name', nil) }
  end

  def menu_section(index)
    reindexed_menu = menu.select {|o| o['subcategories'].any? {|s| ! s.empty? } }
    reindexed_menu[index] or fail 'Intentional 500 Error'
    reindexed_menu[index]['subcategories'].map do |subcategory|
      hash = {'name' => subcategory['name']}
      hash['items'] = subcategory['items']
        .collect {|obj| obj['menu_item_id'] }
        .compact
        .map {|obj_id| MenuItem.find(obj_id).application_hash }
      hash
    end
  end

  def application_menu
    menu
      .select {|o| o['subcategories'].any? {|s| ! s.empty? } }
      .map do |reindexed_menu|
        subcategories = reindexed_menu['subcategories'].map do |subcategory|
          hash = {'name' => subcategory['name']}
          hash['items'] = subcategory['items']
            .collect {|obj| obj['menu_item_id'] }
            .compact
            .map {|obj_id| MenuItem.find(obj_id).application_hash }
          hash
        end
        {name: reindexed_menu['name'], subcategories: subcategories}
      end
  end

  require 'csv'

  def csv_menu
    restaurant_name, restaurant_address = name, address_1

    CSV.generate do |csv|
      csv << %w{restaurant_name restaurant_address menu_name group_name item_name item_prices item_description}
      
      menu.to_a.each do |cat|
        menu_name = cat['name']
        if cat['subcategories'].present?
          cat['subcategories'].each do |group|
            group_name = group['name']
            if group['items'].present?
              group['items'].each do |item_json|
                if item_json['menu_item_id']
                  item = MenuItem.find(item_json['menu_item_id'])
                  item_name = item.name
                  item_prices = item.prices
                  item_description = item.description
                  csv << [restaurant_name, restaurant_address, menu_name, group_name, item_name, item_prices, item_description]
                end
              end
            end
          end
        end
      end
    end
  end
end
