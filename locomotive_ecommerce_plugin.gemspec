# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib/', __FILE__)
$:.unshift lib unless $:.include?(lib)

require "locomotive/ecommerce/plugin/version"

Gem::Specification.new do |spec|
  spec.name        = "locomotive_ecommerce_plugin"
  spec.version     = Locomotive::Ecommerce::VERSION
  spec.platform    = Gem::Platform::RUBY

  spec.authors     = ["Colibri Software"]
  spec.email       = "info@colibri-software.com"
  spec.homepage    = "http://www.colibri-software.com"
  spec.summary     = "Locomotive plugin for ecommerce including a shopping cart"
  spec.homepage    = "http://colibri-software.com"
  spec.license     = "MIT"

  spec.add_dependency "rails", "~> 3.2.13"
  spec.add_dependency 'locomotive_plugins', '~> 1.0'
  spec.add_dependency 'stripe_helper'
  spec.add_dependency 'haml'
  spec.add_dependency 'cells'
  spec.add_dependency 'stripe'
  spec.add_dependency 'kaminari'


  spec.required_rubygems_version = ">= 1.3.6"

  spec.files           = Dir['Gemfile', '{app,config,db,lib}/**/*']
  spec.require_paths   = ["lib"]
end
