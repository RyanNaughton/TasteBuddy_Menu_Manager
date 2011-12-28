module Menupages
  class Page < Menupages::Node

    attr_reader :doc

    def menu
      doc.at('#restaurant-menu')
    end

    def menupages_identifier
      doc
        .at('head')
        .search('meta')
        .detect {|n| n['name'] == 'content.restaurant'}['content']
    end

    def data(restaurant)
      [].tap do |a|
        menu
          .children
          .reject {|o| o.is_a?(Nokogiri::XML::Text) }
          .each do |c|
            case c.name
              when 'h2'
                a << {subcategories: []}.tap do |hash|
                  if c.content.gsub(non_blocking_space, %q{ }).match(/\S/)
                    hash.merge!(name: c.content)
                  end
                end
              when 'h3'
                a.empty? and a << {subcategories: []}
                a.last[:subcategories] << {name: c.content}
              when 'p'
                a.last[:description] = c.content
              when 'table'
                a.last[:subcategories].empty? and a.last[:subcategories] << {}
                a.last[:subcategories].last[:items] = Menupages::Table.new(c).data(restaurant)
            end
          end
      end
    end
  end
end
