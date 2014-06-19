module HbirdEcommerce
  module HbirdEcommerceTagHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
    end
  end

  class CartTag < Liquid::Tag
    include HbirdEcommerceTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_cart(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class CheckoutTag < Liquid::Tag
    include HbirdEcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchase(context["params.p"], @plugin_obj.path,
                                     @plugin_obj.controller)
    end
  end

  class NewCheckoutTag < Liquid::Tag
    include HbirdEcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchase_new(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class PurchasesTag < Liquid::Tag 
    include HbirdEcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchases(@plugin_obj.controller)
    end
  end

  # Non-page tags
  class JavascriptTag < Liquid::Tag
    include HbirdEcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.controller.render_cell 'hbird_ecommerce/javascript', :show
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
