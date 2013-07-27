source 'http://rubygems.org'

gem 'rails', '3.2.13'

# gem 'sqlite3'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.6'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 2.1.1'
  gem 'compass-rails', '~> 1.0.3'
  gem "zurb-foundation", '~> 4.2.3'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

# gem 'haml', "~>3.1.6"
gem 'haml', "~>4.0.3"

gem "bcrypt-ruby", :require => "bcrypt"

gem 'debugger'

group :development do
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false
  gem 'rb-fchange', :require => false
  gem 'rb-readline'
  gem 'guard'
  gem 'guard-livereload'
  # gem 'rack-livereload'
end

group :test, :development do
  gem "rspec-rails", "~> 2.0"
end

gem 'nokogiri'

group :test do
  gem 'turn', :require => false
  gem "minitest", "~> 3.3.0"
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara", "~> 1.1.2"
  gem "capybara-webkit", "~> 0.12.1"
  gem "launchy"
end
