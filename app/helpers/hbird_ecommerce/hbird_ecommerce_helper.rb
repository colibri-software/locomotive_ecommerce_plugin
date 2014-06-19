require 'hbird_ecommerce/inventory_interface'

module HbirdEcommerce
  module HbirdEcommerceHelper
    include ::HbirdEcommerce::HbirdEcommerceCartHelper
    include ::HbirdEcommerce::HbirdEcommerceOrderHelper
    include ::HbirdEcommerce::HbirdEcommerceProductHelper
    include ::HbirdEcommerce::HbirdEcommercePurchaseHelper
    include ::HbirdEcommerce::HbirdEcommerceUrlHelper
    include ::HbirdEcommerce::InventoryInterface

    # User
    def current_user(controller)
      if controller.session[:user_id]
        @current_user ||= IdentityPlugin::User.find(controller.session[:user_id])
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
