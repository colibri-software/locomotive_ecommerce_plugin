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

  class ProductTag < Liquid::Tag
    include HbirdEcommerceTagHelper 
    def render(context)
      super
      @plugin_obj.helper.do_product(context["params.p"],
                                    @plugin_obj.path, @plugin_obj.controller)
    end
  end

  class ProductsTag < Liquid::Tag 
    include HbirdEcommerceTagHelper
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
      @args["product"] = context["params.p"] if context["params.p"]
      @args["vendor"]  = context["params.v"] if context["params.v"]
      @args["group"]   = context["params.g"] if context["params.g"]
      @args["dcs"]     = context["params.c"] if context["params.c"]
      @args["page"]    = context["params.page"] if context["params.page"]
      @plugin_obj.helper.do_products(@args, @plugin_obj.path,
                                     @plugin_obj.controller)
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
