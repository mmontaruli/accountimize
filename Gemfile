source 'http://rubygems.org'

gem 'rails', '3.2.8'

# gem 'sqlite3'
gem 'pg'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  gem 'coffee-rails', '~> 3.2.2'
  gem 'uglifier', '>= 1.0.3'
  gem 'haml', "~>3.1.6"
  gem 'compass-rails', '~> 1.0.3'
  gem "zurb-foundation", '~> 3.0.1'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'
gem "bcrypt-ruby", :require => "bcrypt"


# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug19', :require => 'ruby-debug'
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

group :test do
  gem 'turn', :require => false
  gem 'minitest'
  gem 'cucumber-rails', :require => false
  gem 'database_cleaner'
  gem "factory_girl_rails", "~> 4.0"
  gem "capybara"
  gem "capybara-webkit"
  gem "launchy"
end
