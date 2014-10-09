require 'locomotive/ecommerce/plugin/inventory_interface'

module Locomotive
  module Ecommerce
    module EcommerceHelper
      include ::Locomotive::Ecommerce::EcommerceCartHelper
      include ::Locomotive::Ecommerce::EcommerceUrlHelper
      include ::Locomotive::Ecommerce::InventoryInterface

      # User
      def current_user(controller)
        if controller.session[:user_id]
          site = Thread.current[:site]
          user_from_plugin = site.plugin_object_for_id('identity_plugin').js3_context['identity_plugin_users']
          @current_user ||= user_from_plugin.find(controller.session[:user_id])
        end
      end

      # View Helper
      def as_currency(val)
        "$#{'%.2f' % val}"
      end
    end
  end
end
