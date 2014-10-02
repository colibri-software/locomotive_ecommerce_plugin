module HbirdEcommerce
  module HbirdEcommerceFilters

    def cart_update_path(cart)
      stem = @context.registers[:plugin_object].path
      "#{stem}cart/#{cart.id}"
    end

    def add_to_cart_path(product)
      stem = @context.registers[:plugin_object].path
      "#{stem}add_to_cart/#{product.id}"
    end

    def remove_from_cart_path(product_sku)
      stem = @context.registers[:plugin_object].path
      "#{stem}remove_from_cart/#{product_sku}"
    end

    def checkout_path(purchase)
      stem = @context.registers[:plugin_object].path
      "#{stem}checkout"
    end

    def checkout_update_path(purchase)
      stem = @context.registers[:plugin_object].path
      "#{stem}checkout/#{purchase.id}"
    end

    def find_purchase(id)
      Purchase.find(id.to_s)
    end

    def calculate_shipping(method_name)
      session = @context.registers[:controller].session
      user = IdentityPlugin::User.where(id: session[:user_id]).first
      id = user == nil ? nil : user.id
      if id
        cart = Cart.find_or_create(id, session)
        ct = Thread.current[:site].content_types.where(slug: Engine.config_or_default('shipping_model')).first
        price_break = Engine.config_or_default('price_break').to_f
        name_field = Engine.config_or_default('shipping_name_slug').to_sym
        over_field = Engine.config_or_default('shipping_over_slug').to_sym
        under_field = Engine.config_or_default('shipping_under_slug').to_sym
        query_hash = {}
        query_hash[name_field] = method_name
        method = ct.entries.where(query_hash).first
        if method && cart.purchase_total > price_break
          method.send(over_field).to_f
        elsif method
          method.send(under_field).to_f
        end
      end
    end
  end
end
