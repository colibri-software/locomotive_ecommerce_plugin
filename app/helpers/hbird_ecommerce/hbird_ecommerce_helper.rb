module HbirdEcommerce
  module HbirdEcommerceHelper
    include ::HbirdEcommerce::HbirdEcommerceCartHelper
    include ::HbirdEcommerce::HbirdEcommerceOrderHelper
    include ::HbirdEcommerce::HbirdEcommerceProductHelper
    include ::HbirdEcommerce::HbirdEcommercePurchaseHelper
    include ::HbirdEcommerce::HbirdEcommerceUrlHelper

    # User
    def current_user(controller)
      if controller.session[:user_id]
        @current_user ||= IdentityPlugin::User.find(controller.session[:user_id])
      end
    end

    # Inventory
    def inventory_items
      if Engine.config_or_default('with_quantity')
        HbirdInventory::InventoryUpdate.stable.inventory_items.where(:quantity.gt => 0)
      else
        HbirdInventory::InventoryUpdate.stable.inventory_items
      end
    end

    # Flash
    def do_flash(controller)
      controller.render_cell 'hbird_ecommerce/flash', :show, flash: controller.flash
    end

    # View Helper
    def as_currency(val)
      "$#{'%.2f' % val}"
    end
  end
end
