require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require "ecommerce/engine"

module Ecommerce
  class Ecommerce
    include Locomotive::Plugin

    def self.rack_app
      Engine
    end
  end
end
