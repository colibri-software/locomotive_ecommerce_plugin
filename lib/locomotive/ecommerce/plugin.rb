require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require "locomotive/ecommerce/plugin/engine"
require 'locomotive/ecommerce/plugin/ecommerce_drop'
require 'locomotive/ecommerce/plugin/ecommerce_tags'
require 'locomotive/ecommerce/plugin/ecommerce_filters'
require 'locomotive/ecommerce/plugin/inventory_interface'
require 'cells'
require 'kaminari'
require 'stripe_helper'

module Locomotive
  module Ecommerce
    class PluginHelper
    end

    class Plugin
      include Locomotive::Plugin
      include ::Locomotive::Ecommerce::InventoryInterface

      before_page_render :set_config

      def self.default_plugin_id
        'ecommerce'
      end

      def self.rack_app
        Engine
      end

      def config_template_file
        File.join(File.dirname(__FILE__), 'plugin', 'config.html')
      end

      def to_liquid
        @drop ||= EcommerceDrop.new(self)
      end

      def self.liquid_tags
        {
          stripe:   StripeTag
        }
      end

      def self.liquid_filters
        EcommerceFilters
      end

      def helper
        if !@helper
          @helper = PluginHelper.new
          @helper.instance_eval { extend EcommerceHelper }
        end
        return @helper
      end

      def path
        rack_app_full_path('/')
      end


      private
      def set_config
        mounted_rack_app.config_hash = config
        Remote::Order.site      = Engine.config_or_default('app_url')
        Remote::Order.api_token = Engine.config_or_default('api_token')

        ::Stripe.api_key = mounted_rack_app.config_or_default('stripe_secret')
        ::StripeHelper.configure do |config|
          config.public_key = mounted_rack_app.config_or_default('stripe_public')
        end
      end
    end
  end
end
