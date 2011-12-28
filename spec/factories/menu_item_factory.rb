# Read about factories at http://github.com/thoughtbot/factory_girl

Factory.define :menu_item do |f|
  f.name 'FOOD'
  f.association :restaurant
end

Factory.define :green_curry, :parent => :menu_item do |f|
  f.name 'Green Curry'
  f.association :restaurant, :factory => :silver_spoon
end

Factory.define :pad_thai, :parent => :menu_item do |f|
  f.name 'Pad Thai'
  f.association :restaurant, :factory => :silver_spoon
end

Factory.define :hamburger, :parent => :menu_item do |f|
  f.name 'Chunky Bacon Burger'
  f.association :restaurant, :factory => :hyde_park
end

Factory.define :spagetti, :parent => :menu_item do |f|
  f.name 'Spaghetti Carbonara'
  f.association :restaurant, :factory => :river_north
end
