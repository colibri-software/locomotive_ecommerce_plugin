module HbirdEcommerce
  module HbirdEcommerceTagHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
    end
  end

  class StripeTag < Liquid::Tag
    include HbirdEcommerceTagHelper
    def render(context)
      super
      session = context.registers[:controller].session
      user = IdentityPlugin::User.find(session[:user_id])
      id = user == nil ? nil : user.id
      cart = Cart.find_or_create(id, session)
      @purchase = cart.purchase
      context.registers[:controller].render_cell 'stripe_helper/stripe', :show,
        amount: (@purchase.total.round(2) * 100).to_i,
        desc:   Date.today,
        pk:     StripeHelper.config.public_key,
        stem:   @plugin_obj.path,
        store:  'The Trail Shop',
        token:  @purchase.id
    end
  end

  class FlashTag < Liquid::Tag
    include HbirdEcommerceTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_flash(@plugin_obj.controller)
    end
  end
end
