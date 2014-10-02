source "http://rubygems.org"

# Declare your gem's dependencies in hbird_ecommerce.gemspec.
# Bundler will treat runtime dependencies like base dependencies, and
# development dependencies will be added by default to the :development group.
gemspec

# Stripe helper
gem 'stripe_helper', path: '../../stripe_helper'

# jquery-rails is used by the dummy application
group :test do
  gem 'rspec-rails'
  gem 'capybara'
  gem "factory_girl"
  gem "mocha"
  gem "database_cleaner"
  gem "factory_girl_rails"
  gem "simplecov", require: false
  gem 'shoulda-matchers', require: false
  gem "debugger"
  gem "poltergeist"
end

# gem "locomotive_cms", path: '../../locomotive_engine', require: 'locomotive/engine'
# gem "locomotive_plugins", path: '../../locomotive_plugins'

group :assets do
  gem 'compass-rails',  '~> 1.1.7'
  gem 'sass-rails',     '~> 3.2.4'
  gem 'coffee-rails',   '~> 3.2.2'
  gem 'uglifier',       '~> 1.2.4'
end

group :locomotive_plugins do
  gem "locomotive_ecommerce_plugin", path: '.'
end

# TEMP
gem 'flash-dance', :git => 'https://github.com/MunkiPhD/flash-dance.git' # It may be not being used.
