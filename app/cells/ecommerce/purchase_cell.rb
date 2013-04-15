module Ecommerce
  class PurchaseCell < Cell::Rails
    def new(args)
      @purchase = args[:purchase]
      @stem     = args[:stem]
      @url      = args[:url]
      render
    end

    def show(args)
      @purchase = args[:purchase]
      @cart     = args[:cart]
      @stem     = args[:stem]
      @url      = args[:url]
      render
    end

    def index(args)
      @purchases = args[:purchases]
      @url       = args[:url]
      render
    end
  end
end
