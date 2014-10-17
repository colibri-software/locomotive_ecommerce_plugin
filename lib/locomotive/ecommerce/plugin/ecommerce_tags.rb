module Locomotive
  module Ecommerce
    module EcommerceTagHelper
      def render(context)
        @plugin_obj = context.registers[:plugin_object]
      end
    end

    class StripeTag < ::Liquid::Tag
      include EcommerceTagHelper
      def render(context)
        super
        session = context.registers[:controller].session
        site = Thread.current[:site]
        id = nil
        if session[:user_id]
          user_from_plugin = site.plugin_object_for_id('identity_plugin').js3_context['identity_plugin_users']
          user = user_from_plugin.find(session[:user_id])
          id = user == nil ? nil : user.id
        end
        cart = Cart.find_or_create(id, session)
        @purchase = cart.purchase
        context.registers[:controller].render_cell 'stripe_helper/stripe', :show,
          amount: (@purchase.total.round(2) * 100).to_i,
          desc:   Date.today,
          pk:     StripeHelper.config.public_key,
          stem:   @plugin_obj.path,
          store:  Engine.config_or_default('shop_name'),
          token:  @purchase.id
      end
    end
  end
end
