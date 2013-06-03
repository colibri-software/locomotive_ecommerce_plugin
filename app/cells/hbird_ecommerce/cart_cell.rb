module HbirdEcommerce
  class CartCell < Cell::Rails
    helper HbirdEcommerceHelper

    def show(args)
      @cart = args[:cart]
      render
    end
  end
end
