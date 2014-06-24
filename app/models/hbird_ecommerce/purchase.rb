module HbirdEcommerce
  class Purchase
    include Mongoid::Document
    include Mongoid::Timestamps
    field   :shipping_info, :type => Hash
    field   :completed,     :type => Boolean, :default => false
    field   :user_id,       :type => ::BSON::ObjectId
    field   :transmitted,   :type => Boolean, :default => false
    field   :stripe_token,  :type => String
    has_one :cart,          :class_name => "::HbirdEcommerce::Cart"

    def complete
      cart.orders.each { |order| order.product_quantity -= order.quantity }
    end

    def to_liquid
      PurchaseDrop.new(self)
    end

    delegate :subtotal_est_tax, to: :cart

    def shipping_estimate
      0.0
    end

    def subtotal_est_shipping
      subtotal_est_tax + shipping_estimate
    end

    def tax
      0.0
    end

    def shipping
      0.0
    end

    def total
      cart.purchase_total + tax + shipping
    end

  end

  class PurchaseDrop < ::Liquid::Drop
    def initialize(source)
      @source = source
    end

    def id
      @source.id.to_s
    end

    delegate :cart, :complete, :stripe_token, :completed,
      :subtotal_est_tax, :shipping_estimate, :subtotal_est_shipping,
      :shipping, :tax, :total, :shipping_info, to: :@source

    def method_missing(meth, *args, &block)
      if @source.shipping_info.key?(meth)
        @source.shipping_info[meth]
      else
        super
      end
    end

    protected
    attr_accessor :source
  end
end
