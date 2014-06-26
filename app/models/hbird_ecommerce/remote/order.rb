module HbirdEcommerce
  module Remote
    class Order < ActiveResource::Base
      class << self
        attr_accessor :api_token
        element_name = 'order'
      end
      def save
        prefix_options[:api_token] = self.class.api_token
        super
      end
    end
  end
end
