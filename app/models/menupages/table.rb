module Menupages
  class Table < Menupages::Node
    def data(restaurant)
      [].tap do |a|
        doc.at('tbody').children.each do |elem|
          if elem['class'] == 'sub'
            a.last[:options] ||= []
            a.last[:options] << Menupages::RowOption.new(elem).data
          else
            a << Menupages::Row.new(elem).data(restaurant)
          end
        end
      end
    end
  end
end
