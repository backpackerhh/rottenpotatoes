source 'http://rubygems.org'

gem 'rails', '3.2.18'
gem 'jquery-rails'
gem 'haml-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'therubyracer'              
  gem 'sass-rails'
  gem 'coffee-rails'
  gem 'uglifier'
end

# for Heroku deployment - as described in Ap. A of ELLS book
group :development, :test do
  gem 'sqlite3'
  gem 'debugger'
  gem 'rspec-rails', '3.0.1'
  gem 'annotate', require: false
  gem 'simplecov', require: false
end

group :test do
  gem 'cucumber-rails', require: false
  gem 'database_cleaner'
  gem 'capybara'
end

group :production do
  gem 'pg'
end
