module Ecommerce
  module Remote
    class Order < ActiveResource::Base
      self.site = "http://localhost:3030"
    end
  end
end
