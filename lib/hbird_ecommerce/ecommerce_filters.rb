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

    def remove_from_cart_path(product)
      stem = @context.registers[:plugin_object].path
      "#{stem}remove_from_cart/#{product.id}"
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
  end
end
