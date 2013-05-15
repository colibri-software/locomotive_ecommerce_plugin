module HbirdEcommerce
  module Remote
    class Order < ActiveResource::Base
      self.element_name = 'order'
    end
  end
end
