# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "ecommerce/version"

Gem::Specification.new do |s|
  s.name        = "ecommerce"
  s.version     = Ecommerce::VERSION
  s.platform    = Gem::Platform::RUBY

  s.authors     = ["Colibri Software"]
  s.email       = "info@colibri-software.com"
  s.homepage    = "http://www.colibri-software.com"
  s.summary     = "Locomotive plugin for ecommerce including a shopping cart, inventory & user accounts."

  s.add_dependency "rails", "~> 3.2.13"
  s.add_dependency 'locomotive_plugins',    '~> 1.0.0.beta10'

  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'simplecov'

  s.required_rubygems_version = ">= 1.3.6"

  s.files           = Dir['Gemfile', '{app,config,db,lib}/**/*']
  s.require_paths   = ["lib"]
end
