# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

require 'csv'

if Restaurant::CuisineTypeOption.count.zero?
  cuisine_types_data_path = Rails.root.join(*%w(db seeds restaurant cuisine_types.csv))
  CSV.foreach(cuisine_types_data_path, :headers => true) do |row|
    Restaurant::CuisineTypeOption.create!(row.to_hash)
  end
end

if Restaurant::Neighborhood.count.zero?
  neighborhoods_data_path = Rails.root.join(*%w(db seeds restaurant neighborhoods.csv))
  CSV.foreach(neighborhoods_data_path, :headers => true) do |row|
    Restaurant::Neighborhood.create!(row.to_hash)
  end
end

if Tag.count.zero?
  default_tags_data_path = Rails.root.join(*%w(db seeds tags.csv))
  CSV.foreach(default_tags_data_path, :headers => true) do |row|
    Tag.create!(row.to_hash)
  end
end

User.where(username: 'wtn').first or User.create!(
  username: 'wtn',
  first_name: 'William T',
  last_name: 'Nelson',
  email: 'william.nelson@argonavisconsulting.com',
  password: 'administrator',
  password_confirmation: 'administrator',
  postal_code: '00000',
  country: 'United States',
  roles: %w{admin},
)
