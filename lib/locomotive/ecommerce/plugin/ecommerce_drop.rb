module Locomotive
  module Ecommerce
    class EcommerceDrop < ::Liquid::Drop
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

      def show_out_of_stock?
        !!Engine.config_or_default('with_quantity')
      end

      def cart
        unless @cart
          session = @context.registers[:controller].session
          site = Thread.current[:site]
          user_from_plugin = site.plugin_object_for_id('identity_plugin').js3_context['identity_plugin_users']
          user = user_from_plugin.where(id: session[:user_id]).first
          id = user == nil ? nil : user.id
          @cart = Cart.find_or_create(id, session)
        end
        @cart
      end

      def purchase
        unless @purchase
          session = @context.registers[:controller].session
          site = Thread.current[:site]
          user_from_plugin = site.plugin_object_for_id('identity_plugin').js3_context['identity_plugin_users']
          user = user_from_plugin.where(id: session[:user_id]).first
          puts "Count in Drop 1: #{Purchase.count}"
          @purchase = cart.purchase || Purchase.new
          cart.purchase = @purchase
          cart.save!
          @purchase.save!
          puts "Count in Drop 2: #{Purchase.count}"
        end
        @purchase
      end

      def purchases
        session = @context.registers[:controller].session
        site = Thread.current[:site]
        user_from_plugin = site.plugin_object_for_id('identity_plugin').js3_context['identity_plugin_users']
        user = user_from_plugin.where(id: session[:user_id]).first
        Purchase.where(user_id: user.id).all.to_a
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
            if field == :category
              v.split(' ').each do |value|
                regex = /^#{Regexp.escape(value)}.*/i
                products = products.or(category: regex)
              end
            else
              regex = /#{Regexp.escape(v)}/i
              products = products.and(field => regex)
            end
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
end