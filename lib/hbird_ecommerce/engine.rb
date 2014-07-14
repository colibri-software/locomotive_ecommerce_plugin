#require 'omniauth-identity'

module HbirdEcommerce
  class Engine < ::Rails::Engine
    isolate_namespace HbirdEcommerce

    def self.config_hash=(hash)
      @config_hash = hash
    end

    def self.config_hash
      @config_hash ||= {}
    end

    def self.config_or_default(key)
      defaults = {
        'cart_url' => '/cart',
        'checkout_url' => '/checkout',
        'post_checkout_url' => '/complete',
        'confirm_order_url' => '/confirm',
        'purchases_url' => '/purchases',
        'estimated_tax_rate' => '15',
        'country_slug' => 'country',
        'province_slug' => 'province',
        'precentage_slug' => 'precentage',
        'shipping_name_slug' => 'name',
        'shipping_over_slug' => 'over',
        'shipping_under_slug' => 'under',
        'price_break' => '100',
        'shop_name' => "<insert name>",
        'contact' => "fake@email.com"
      }
      hash = defaults.merge(config_hash)
      hash[key]
    end
  end
end
