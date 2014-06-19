module HbirdEcommerce
  class HbirdEcommerceDrop < ::Liquid::Drop
    def initialize(source)
      @source = source
      urls = ['cart_url', 'checkout_url', 'new_checkout_url', 'product_url',
        'products_url', 'purchases_url']
      urls.each do |name|
        self.class.send(:define_method, name) do
          source.mounted_rack_app.config_or_default(name)
        end
      end
    end

    def products
      search_filter(source.inventory_items)
    end

    protected
    attr_reader :source

    def search_filter(products)
      params = @context['params']
      whitelist = {
        'sku'      => :sku,
        'product'  => :description,
        'price'    => :price,
        'quantity' => :quantity,
        'vendor'   => :vendor,
        'group'    => :group,
        'dcs'      => :category
      }

      params.each do |k,v|
        k_split = k.split('_')
        last    = k_split.size > 1 ? k_split.delete_at(-1) : nil
        first   = k_split.join('_')
        next if !whitelist.key? first
        field = whitelist[first].to_sym
        if last == nil
          regex = /#{Regexp.escape(v)}/i
          regex = /^#{Regexp.escape(v)}.*/i if field == :category
          products = products.and(field => regex)
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
