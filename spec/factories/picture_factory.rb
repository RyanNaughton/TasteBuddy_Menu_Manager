Factory.define :picture do |f|
  f.association :user
  f.location_description 'chez toi'
end

Factory.define :gadaffi, :parent => :picture do |f|
  f.location_description 'Libya'
  f.attachment File.new(Rails.root + 'spec/fixtures/gadaffi.png')
end
