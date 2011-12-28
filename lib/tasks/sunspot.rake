namespace :sunspot do 
  desc 'Index searchable models'
  task :index => :environment do
    models = [Restaurant, MenuItem, Restaurant::Neighborhood]
    models.each {|model| Sunspot.index!(model.all)}
  end
end
