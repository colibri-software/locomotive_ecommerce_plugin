module Locomotive
  module Ecommerce
    module EcommerceCartHelper
      def current_user_cart(controller)
        user = current_user(controller)
        id = user == nil ? nil : user.id
        Cart.find_or_create(id, controller.session)
      end
    end
  end
end
