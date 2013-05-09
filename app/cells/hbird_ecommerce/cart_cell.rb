module HbirdEcommerce
  class CartCell < Cell::Rails
    def show(args)
      @cart = args[:cart]
      render
    end
  end
end
