module Ecommerce
  module EcommerceTagHelper
    def render(context)
      @plugin_obj = context.registers[:plugin_object]
    end
  end

  class CartTag < Liquid::Tag
    include EcommerceTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_cart(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class CheckoutTag < Liquid::Tag
    include EcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchase(context["params.p"], @plugin_obj.path,
                                     @plugin_obj.controller)
    end
  end

  class NewCheckoutTag < Liquid::Tag
    include EcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchase_new(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class ProductTag < Liquid::Tag
    include EcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_product(context["params.p"],
                                    @plugin_obj.path, @plugin_obj.controller)
    end
  end

  class ProductsTag < Liquid::Tag 
    include EcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_products(@plugin_obj.path, @plugin_obj.controller)
    end
  end

  class PurchasesTag < Liquid::Tag 
    include EcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchases(@plugin_obj.controller)
    end
  end
end
