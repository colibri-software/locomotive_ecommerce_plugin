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
      if precent = tax_precentage
        cart.purchase_total * (precent.to_f/100)
      else
        -1
      end
    end

    def tax_precentage
      unless @tax_precentage
        ct = Thread.current[:site].content_types.where(slug: Engine.config_or_default('tax_model')).first
        if ct
          query_hash = {}
          country_field = Engine.config_or_default('country_slug').to_sym
          province_field = Engine.config_or_default('province_slug').to_sym
          precentage_field = Engine.config_or_default('precentage_slug').to_sym
          query_hash[country_field] = /#{shipping_info[country_field.to_s]}/i
          query = ct.entries.where(query_hash)
          if query.count == 1
            @tax_precentage = query.first.send(precentage_field)
          elsif query.count > 0
            query_hash = {}
            query_hash[province_field] = /#{shipping_info[province_field.to_s]}/i
            query = query.and(query_hash)
            if query.count > 0
              @tax_precentage = query.first.send(precentage_field)
            else
              @tax_precentage = nil
            end
          else
            @tax_precentage = nil
          end
        else
          @tax_precentage = nil
        end
      end
      @tax_precentage
    end

    def shipping
      0.0
    end

    def total
      if tax >= 0
        cart.purchase_total + tax + shipping
      else
        cart.purchase_total + shipping
      end
    end

  end

  class PurchaseDrop < ::Liquid::Drop
    def initialize(source)
      @source = source
    end

    def id
      @source.id.to_s
    end

    def date
      @source.updated_at
    end

    [:subtotal_est_tax, :shipping_estimate, :subtotal_est_shipping,
      :shipping, :tax, :tax_precentage, :total].each do |method|
      define_method(method) {@source.send(method).round(2)}
      end

    delegate :cart, :complete, :stripe_token, :completed, :shipping_info, to: :@source

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
