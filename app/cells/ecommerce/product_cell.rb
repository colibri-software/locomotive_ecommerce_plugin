module Ecommerce
  class ProductCell < Cell::Rails
    def index(args)
      @products = args[:products]
      @stem     = args[:stem]
      @url      = args[:url]
      render
    end

    def show(args)
      @product = args[:product]
      @stem    = args[:stem]
      @url     = args[:url]
      render
    end
  end
end
