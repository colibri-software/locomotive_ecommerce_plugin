module Ecommerce
  module EcommerceProductHelper
    def do_product(product_id, path, controller)
      product = inventory_items.where(:_id => product_id).first
      controller.render_cell 'ecommerce/product', :show,
        product: product, url: self, stem: path
    end

    def do_products(params, path, controller)
      products = filter_products(inventory_items, params)
      controller.render_cell 'ecommerce/product', :index,
        products: products, url: self, stem: path
    end

    private
    def filter_products(products, params)
      whitelist = {
        'sku'      => :sku,
        'product'  => :description,
        'price'    => :product_price,
        'quantity' => :quantity,
        'vendor'   => :vendor,
        'group'    => :group
      }

      params.each do |k,v|
        k_split = k.split('_')
        last    = k_split.size > 1 ? k_split.delete_at(-1) : nil
        first   = k_split.join('_')
        next if !whitelist.key? first
        field = whitelist[first].to_sym
        if last == nil
          products = products.and(field => /#{Regexp.escape(v)}/i)
        elsif last == 'min'
          products = products.and(field.gt => v)
        elsif last == 'max'
          products = products.and(field.lt => v)
        elsif last == 'sort'
          if v == 'asc'
            products = products.asc(field)
          elsif v == 'desc'
            products = products.desc(field)
          end
        end
      end
      products
    end
  end
end
