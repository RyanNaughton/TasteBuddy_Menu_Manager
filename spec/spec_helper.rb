# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join('spec/support/**/*.rb')].each {|f| require f}

# Load factories in nested folders
Dir[Rails.root.join('spec/factories/**/*.rb')].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  # config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  # config.use_transactional_fixtures = false

  # config.before :each do
  #   Mongoid.master.collections.select {|c| ! c.name.include?('system') }.each(&:drop)
  # end

  require 'database_cleaner'
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid'
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.include Devise::TestHelpers, :type => :controller


  # Start up a Solr instance
  `sunspot-solr start -- -p 8981`
  sleep 5 # allow some time for the instance to spin up

  at_exit do
    `ps ax|egrep "Dsolr.solr.home=/usr/local/rvm/gems/ruby"|grep -v grep|awk '{print $1}'|xargs kill`
  end
end
