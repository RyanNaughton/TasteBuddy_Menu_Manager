Factory.define :user do |f|
  f.first_name 'Eddie'
  f.last_name 'Donner'
  f.postal_code '05753'
  f.country 'United States'
  f.email 'user@example.com'
  f.password 'nN<$Y!#hwx'
end

Factory.define :admin, :parent => :user do |f|
  f.roles %w{admin}
end
