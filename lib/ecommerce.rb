require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require "ecommerce/engine"
require 'ecommerce/ecommerce_drop'
require 'ecommerce/ecommerce_tags'
require 'cells'

module Ecommerce
  class PluginHelper
  end

  class Ecommerce
    include Locomotive::Plugin

    before_rack_app_request :set_config

    def self.rack_app
      Engine
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'ecommerce', 'config.html')
    end

    def to_liquid
      @drop ||= EcommerceDrop.new(self)
    end

    def self.liquid_tags
      {
        cart:         CartTag,
        checkout:     CheckoutTag,
        new_checkout: NewCheckoutTag,
        product:      ProductTag,
        products:     ProductsTag,
        purchases:    PurchasesTag
      }
    end

    def helper
      if !@helper
        @helper = PluginHelper.new
        @helper.instance_eval { extend EcommerceHelper }
      end
      return @helper
    end

    def path
      '/locomotive/plugins/ecommerce/'
    end

    private
    def set_config
      mounted_rack_app.config_hash = config
    end
  end
end
