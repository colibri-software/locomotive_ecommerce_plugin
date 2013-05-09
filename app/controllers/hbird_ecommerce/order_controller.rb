module HbirdEcommerce
  class OrderController < ::HbirdEcommerce::ApplicationController
    def create
      do_order_create(params, self)
    end

    def destroy
      do_order_destroy(params, self)
    end
  end
end
