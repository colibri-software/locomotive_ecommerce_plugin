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
      msg = config_hash[key]
      return msg if msg && msg.class == String ? !msg.empty? : true

      return '/cart'         if key == 'cart_url'
      return '/checkout'     if key == 'checkout_url'
      return '/checkout_new' if key == 'new_checkout_url'
      return '/product'      if key == 'product_url'
      return '/products'     if key == 'products_url'
      return '/purchases'    if key == 'purchases_url'
    end
  end
end
