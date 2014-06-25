module HbirdEcommerce
  module HbirdEcommerceUrlHelper
    ##################
    # configured urls
    ##################
    def cart_path(*args)
      Engine.config_or_default('cart_url')
    end

    def checkout_path
      Engine.config_or_default('checkout_url')
    end

    def confirm_order_path
      Engine.config_or_default('confirm_order_url')
    end

    def purchases_path
      Engine.config_or_default('purchases_url')
    end

    def post_checkout_path
      Engine.config_or_default('post_checkout_url')
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
