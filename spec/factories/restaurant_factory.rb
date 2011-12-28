Factory.define :restaurant do |f|
  f.name 'Silver Spoon'
  f.address_1 '710 N Rush St'
  f.city_town 'Chicago'
  f.state_province 'IL'
  f.country 'US'
end

Factory.define :silver_spoon, :parent => :restaurant do |f|
  f.cuisine_types %w{Thai}
  f.latitude 41.895366
  f.longitude -87.62578
end

Factory.define :hyde_park, :parent => :restaurant do |f|
  f.name 'Bar Louie'
  f.address_1 '5500 S Shore Dr'
  f.latitude 41.796153
  f.longitude -87.580843
end

Factory.define :river_north, :parent => :restaurant do |f|
  f.name 'Quartino'
  f.address_1 '626 N State St'
  f.latitude 41.8934332
  f.longitude -87.6283246
end
