require 'rubygems'
require 'bundler/setup'
require 'locomotive_plugins'
require "hbird_ecommerce/engine"
require 'hbird_ecommerce/ecommerce_drop'
require 'hbird_ecommerce/ecommerce_tags'
require 'hbird_ecommerce/ecommerce_filters'
require 'hbird_ecommerce/inventory_interface'
require 'cells'
require 'kaminari'

module HbirdEcommerce
  class PluginHelper
  end

  class HbirdEcommerce
    include Locomotive::Plugin
    include ::HbirdEcommerce::InventoryInterface

    before_page_render :set_config

    def self.rack_app
      Engine
    end

    def config_template_file
      File.join(File.dirname(__FILE__), 'hbird_ecommerce', 'config.html')
    end

    def to_liquid
      @drop ||= HbirdEcommerceDrop.new(self)
    end

    def self.liquid_tags
      {
        stripe:   StripeTag,
        flash:    FlashTag
      }
    end

    def self.liquid_filters
      HbirdEcommerceFilters
    end

    def helper
      if !@helper
        @helper = PluginHelper.new
        @helper.instance_eval { extend HbirdEcommerceHelper }
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
