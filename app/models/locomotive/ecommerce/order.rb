module Locomotive
  module Ecommerce
    class Order
      include Mongoid::Document
      include ::Mongoid::Timestamps
      field      :quantity,   :type => Integer, :default => 1
      field      :sku,        :type => String
      belongs_to :cart,       :class_name => "::Locomotive::Ecommerce::Cart"

      def quantity=(value)
        begin
          new_quantity = Integer(value)
        rescue
          return false
        end
        self[:quantity] = new_quantity
        cart.remove_product_by_sku(sku) if new_quantity < 1
      end

      def quantity
        self[:quantity]
      end

      def product_price
        i = product
        i == nil ? 0 : i.price(sku).to_f
      end

      def product_name
        i = product
        i == nil ? '' : i.description
      end

      def product_quantity
        i = product
        i == nil ? 0 : i.quantity(sku)
      end

      def product_quantity=(value)
        i = product
        i.set_quantity(value, sku)
        i.save!
      end

      def price
        quantity * product_price
      end

      def out_of_stock?
        quantity > product_quantity
      end

      def to_liquid
        OrderDrop.new(self)
      end

      def self.id_to_sku(id)
        ret = product_class.where(:_id => id).first
        ret ? ret.sku : nil
      end

      def product
        self.class.product_class.find_by_sku(sku)
      end

      def size
        product.size(sku)
      end

      def color
        product.color(sku)
      end

      private
      def self.product_class
        site = Thread.current[:site]
        site.plugin_object_for_id('inventory').js3_context.eval(Engine.config_or_default('shop_inventory_items'))
        # site.plugin_object_for_id('inventory').js3_context['inventory_items']
        # HbirdInventory::InventoryItem
      end
    end
    class OrderDrop < ::Liquid::Drop
      def initialize(source)
        @source = source
      end

      def id
        @source.id.to_s
      end

      def price
        "%0.2f" % @source.price.round(2)
      end

      delegate :size, :color, :sku, :product, :out_of_stock?, :quantity,
        :product_quantity, :cart, to: :@source

      protected
      attr_accessor :source
    end
  end
end