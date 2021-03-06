module Locomotive
  module Ecommerce
    class Order
      include Mongoid::Document
      include ::Mongoid::Timestamps
      include InventoryInterface
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

      def price
        quantity * product_price.to_f
      end

      def out_of_stock?
        quantity > product_quantity
      end

      def self.id_to_sku(id)
        ret = product_class.where(:_id => id).first
        ret ? ret.sku : nil
      end

      def product
        klass = self.class.product_class

        if klass.respond_to?(:find_by_sku)
          klass.find_by_sku(sku)
        else
          klass.where(sku: sku).first
        end
      end

      [:size, :color, :quantity, :price, :name].each do |method|
        defined = "product_#{method}".to_sym
        default = [:quantity, :price].include?(method)? 0 : ''
        method = :description if method == :name
        define_method(defined) do
          i = product
          if i == nil
            default
          else
            if i.public_method(method).arity == 0
              i.send(method)
            elsif i.public_method(method).arity == 0
              i.send(method, sku)
            end
          end
        end
      end

      def product_quantity=(value)
        i = product
        if i.respond_to?(:set_quantity)
          i.set_quantity(value, sku)
        else
          i.quantity = value
        end
        i.save!
      end

      def to_liquid
        OrderDrop.new(self)
      end

      private

      def self.product_class
        inventory_items_class
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

      def product_price
        "%0.2f" % @source.product_price.round(2)
      end

      [:size, :color, :name].each do |method|
        defined = "product_#{method}".to_sym
        define_method(method) do
          @source.send(defined)
        end
      end

      delegate :sku, :product, :quantity, :out_of_stock?, :product_quantity, :cart, to: :@source

      protected

      attr_accessor :source
    end
  end
end
