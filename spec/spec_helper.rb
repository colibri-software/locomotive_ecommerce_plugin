require 'simplecov'
SimpleCov.start 'rails'
require 'rubygems'

ENV['RAILS_ENV'] ||= 'test'

require File.expand_path("../dummy/config/environment.rb", __FILE__)

require 'factory_girl_rails'
require 'rspec/rails'
require 'rspec/autorun'
require 'capybara/rails'
require 'capybara/rspec'
Rails.backtrace_cleaner.remove_silencers!
require 'database_cleaner'

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
Capybara.default_wait_time = 30

RSpec.configure do |config|
  config.color_enabled = true
  config.formatter     = 'documentation'
  config.include Locomotive::Ecommerce::Engine.routes.url_helpers
  
  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.orm = 'mongoid' 
  end

  config.after(:suite) do
    DatabaseCleaner.clean
  end

  config.before(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.include FactoryGirl::Syntax::Methods
end
