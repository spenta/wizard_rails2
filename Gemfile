source 'http://rubygems.org'
gem 'rails', '~> 3.1'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

#gem 'mysql2'
#gem 'sprockets'
gem "mongoid", "~> 2.2"
gem "bson_ext", "~> 1.3"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1"
  gem 'coffee-rails', "~> 3.1"
  gem 'uglifier'
end

gem 'jquery-rails'

group :test, :development, :cucumber do
  gem 'rspec-rails'
  gem 'spork', '~> 0.9.0.rc'
end

group :test, :cucumber do
  gem 'cucumber-rails'
  gem 'fabrication'
  gem 'capybara'
  gem 'database_cleaner'
  #gem 'sqlite3'
  # Pretty printed test output
  gem 'turn', :require => false
  gem 'webrat' 
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem 'execjs'
gem 'therubyracer'
