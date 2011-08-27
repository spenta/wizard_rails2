source 'http://rubygems.org'
gem 'rails', '3.1.0.rc5'
#gem 'thin'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
group :production do
  gem 'pg'
end
#gem 'mysql2'
gem 'sprockets', "2.0.0.beta13"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails', "~> 3.1.0.rc"
  gem 'coffee-script'
  #gem 'uglifier'
end

gem 'jquery-rails'

group :test, :development do
  gem 'rspec-rails'
  gem 'spork', '~> 0.9.0.rc'
end

group :test do
  gem 'cucumber-rails'
  gem 'factory_girl_rails'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'sqlite3'
  # Pretty printed test output
  gem 'turn', :require => false
end
# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
gem 'execjs'
#gem 'therubyracer'
