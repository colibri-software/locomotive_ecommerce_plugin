module HbirdEcommerce
  class CartPageCell < Cell::Rails
    helper HbirdEcommerceHelper

    def show(args)
      @cart = args[:cart]
      @stem = args[:stem]
      @url  = args[:url]
      render
    end
  end
end
