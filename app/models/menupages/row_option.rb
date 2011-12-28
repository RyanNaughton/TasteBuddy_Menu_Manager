module Menupages
  class RowOption < Menupages::Node
    def data
      { name: name, prices: prices }
    end

    private

    def prices
      doc
        .search('td')
        .map(&:content)
        .map {|str| str.sub(non_blocking_space, empty_str) }
        .reject {|str| str.to_f.zero? }
        .map(&:to_f)
    end

    def name
      doc.at('cite').content
    end
  end
end
