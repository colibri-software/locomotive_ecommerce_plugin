module Ecommerce
  module EcommerceProductHelper
    def do_product(product_id, path, controller)
      product = inventory_items.where(:_id => product_id).first
      controller.render_cell 'ecommerce/product', :show,
        product: product, url: self, stem: path
    end

    def do_products(path, controller)
      products = inventory_items
      controller.render_cell 'ecommerce/product', :index,
        products: products, url: self, stem: path
    end
  end
end
