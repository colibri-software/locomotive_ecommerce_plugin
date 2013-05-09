module HbirdEcommerce
  module HbirdEcommerceUrlHelper
    ##################
    # configured urls
    ##################
    def cart_path(*args)
      Engine.config_or_default('cart_url')
    end

    def checkout_path(purchase)
      "#{Engine.config_or_default('checkout_url')}?p=#{purchase.id}"
    end

    def new_checkout_path
      Engine.config_or_default('new_checkout_url')
    end

    def product_path(product)
      "#{Engine.config_or_default('product_url')}?p=#{product.id}"
    end

    def products_path
      Engine.config_or_default('products_url')
    end

    ###########################
    # non-configured urls
    # (provided by the engine)
    # #########################
    def cart_update_path(stem, cart)
      "#{stem}cart/#{cart.id}"
    end
    
    def add_to_cart_path(stem, product)
      "#{stem}add_to_cart/#{product.id}"
    end

    def remove_from_cart_path(stem, product_id)
      "#{stem}remove_from_cart/#{product_id}"
    end
    
    def checkout_update_path(stem, purchase)
      "#{stem}checkout/#{purchase.id}"
    end
    
    def checkout_index_path(stem)
      "#{stem}checkout"
    end
  end
end
