module Ecommerce
  class CartController < ::Ecommerce::ApplicationController
    def update
      do_cart_update(params, self)
    end
  end
end
