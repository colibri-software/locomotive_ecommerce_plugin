module HbirdEcommerce
  class CartController < ::HbirdEcommerce::ApplicationController
    def update
      do_cart_update(params, self)
    end
  end
end
