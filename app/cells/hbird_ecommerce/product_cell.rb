module HbirdEcommerce
  class ProductCell < Cell::Rails
    helper HbirdEcommerceHelper

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
