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
        'new_checkout_url' => '/checkout_new',
        'confirm_order_url' => '/confirm',
        'product_url' => '/product',
        'products_url' => '/products',
        'purchases_url' => '/purchases',
        'estimated_tax_rate' => '15',
      }
      hash = defaults.merge(config_hash)
      hash[key]
    end
  end
end
