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
    Syntax = /(#{::Liquid::Expression}+)?/

    def initialize(tag_name, markup, tokens, context)
      @args = {}
      if markup =~ Syntax
        markup.scan(::Liquid::TagAttributes) { |key,value| @args[key] = value }
      else
        raise ::Liquid::SyntaxError.new("Syntax error in 'products' ")
      end
    end

    def render(context)
      super
      @plugin_obj.helper.do_products(@args, @plugin_obj.path,
                                     @plugin_obj.controller)
    end
  end

  class PurchasesTag < Liquid::Tag 
    include EcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_purchases(@plugin_obj.controller)
    end
  end

  # Non-page tags
  class JavascriptTag < Liquid::Tag
    def render(context)
      '
<script src="//ajax.googleapis.com/ajax/libs/jquery/1.9.1/jquery.min.js"></script>
<script src="/assets/jquery_ujs.js" type="text/javascript"></script>'
    end
  end

  class FlashTag < Liquid::Tag
    include EcommerceTagHelper
    def render(context)
      super
      @plugin_obj.helper.do_flash(@plugin_obj.controller)
    end
  end
end
