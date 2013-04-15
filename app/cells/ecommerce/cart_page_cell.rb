module Ecommerce
  class CartPageCell < Cell::Rails
    def show(args)
      @cart = args[:cart]
      @stem = args[:stem]
      @url  = args[:url]
      render
    end
  end
end
