module HbirdEcommerce
  class FlashCell < Cell::Rails
    def show(args)
      @flash = args[:flash]
      render
    end
  end
end
