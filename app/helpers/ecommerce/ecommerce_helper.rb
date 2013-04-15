module Ecommerce
  module EcommerceHelper
    include ::Ecommerce::EcommerceCartHelper
    include ::Ecommerce::EcommerceOrderHelper
    include ::Ecommerce::EcommerceProductHelper
    include ::Ecommerce::EcommercePurchaseHelper
    include ::Ecommerce::EcommerceUrlHelper

    # User
    def current_user(controller)
      if controller.session[:user_id]
        @current_user ||= IdentityEngine::User.find(controller.session[:user_id])
      end
    end

    # Inventory
    def inventory_items
      Inventory::InventoryUpdate.stable.inventory_items
    end
  end
end
