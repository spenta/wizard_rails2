require 'rubygems'
require 'spork'

Spork.prefork do
  # This file is copied to spec/ when you run 'rails generate rspec:install'
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

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
    #config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    config.use_transactional_fixtures = true
  end
end
Spork.each_run do
  #ActiveSupport::Dependencies.clear
  #ActiveRecord::Base.instantiate_observers
  #FactoryGirl.factories.clear
  #require 'factory_girl_rails'
  ##FactoryGirl.find_definitions
  #Dir.glob(File.join(File.dirname(__FILE__), '../../spec/factories/
#> *.rb')).each {|f| require f }
  #Dir[Rails.root.join('spec/factories/**/*.rb')].each{|f| load f}
end if Spork.using_spork?
