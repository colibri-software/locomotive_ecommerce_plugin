module Locomotive
  module Ecommerce
    class Purchase
      include Mongoid::Document
      include ::Mongoid::Timestamps
      field   :shipping_info,   :type => Hash, :default => {}
      field   :shipping_method, :type => String
      field   :completed,       :type => Boolean, :default => false
      field   :user_id,         :type => ::BSON::ObjectId
      field   :transmitted,     :type => Boolean, :default => false
      field   :stripe_token,    :type => String
      has_one :cart,            :class_name => "::Locomotive::Ecommerce::Cart"

      def self.complete(purchase_id, user, cart, stripeToken, session)
        purchase = Purchase.where(_id: purchase_id).first

        #Reset user cart
        purchase.cart.user_id = nil
        purchase.cart.save!
        new_cart = Cart.create
        new_cart.user_id = user.id if user
        new_cart.save!
        session[:cart_id] = new_cart.id

        #complete purchase
        purchase.stripe_token = stripeToken
        purchase.complete
        purchase.completed = true
        purchase.user_id = user.id if user
        purchase.save!
        if user
          PurchaseMailer.purchase_confirmation(user, purchase).deliver
        end
        after_purchase_hook(purchase, user)
      end

      def complete
        cart.orders.each { |order| order.product_quantity -= order.quantity }
      end

      def to_liquid
        PurchaseDrop.new(self)
      end

      delegate :subtotal_est_tax, to: :cart

      def shipping_estimate
        unless @shipping_estimate
          @shipping_estimate = 0.0
          ct = Thread.current[:site].content_types.where(slug: Engine.config_or_default('shipping_model')).first
          price_break = Engine.config_or_default('price_break').to_f
          over_field = Engine.config_or_default('shipping_over_slug').to_sym
          under_field = Engine.config_or_default('shipping_under_slug').to_sym
          method = ct.ordered_entries.first
          if self.cart.purchase_total > price_break
            @shipping_estimate = method.send(over_field).to_f
          else
            @shipping_estimate = method.send(under_field).to_f
          end
        end
        @shipping_estimate
      end

      def subtotal_est_shipping
        subtotal_est_tax + shipping_estimate
      end

      def tax
        if precent = tax_percentage
          cart.purchase_total * (precent.to_f/100)
        else
          -1
        end
      end

      def tax_percentage
        unless @tax_percentage
          ct = Thread.current[:site].content_types.where(slug: Engine.config_or_default('tax_model')).first
          if ct
            query_hash = {}
            country_field = Engine.config_or_default('country_slug').to_sym
            province_field = Engine.config_or_default('province_slug').to_sym
            percentage_field = Engine.config_or_default('percentage_slug').to_sym
            query_hash[country_field] = /#{shipping_info[country_field.to_s]}/i
            query = ct.entries.where(query_hash)
            if query.count == 1
              @tax_percentage = query.first.send(percentage_field)
            elsif query.count > 0
              query_hash = {}
              query_hash[province_field] = /#{shipping_info[province_field.to_s]}/i
              query = query.and(query_hash)
              if query.count > 0
                @tax_percentage = query.first.send(percentage_field)
              else
                @tax_percentage = nil
              end
            else
              @tax_percentage = nil
            end
          else
            @tax_percentage = nil
          end
        end
        @tax_percentage
      end

      def shipping
        unless @shipping
          @shipping = 0.0
          ct = Thread.current[:site].content_types.where(slug: Engine.config_or_default('shipping_model')).first
          price_break = Engine.config_or_default('price_break').to_f
          name_field = Engine.config_or_default('shipping_name_slug').to_sym
          over_field = Engine.config_or_default('shipping_over_slug').to_sym
          under_field = Engine.config_or_default('shipping_under_slug').to_sym
          query_hash = {}
          query_hash[name_field] = self.shipping_method
          method = ct.entries.where(query_hash).first
          if self.cart.purchase_total > price_break
            @shipping = method.send(over_field).to_f
          else
            @shipping = method.send(under_field).to_f
          end
        end
        @shipping
      end


      def total
        if tax >= 0
          cart.purchase_total + tax + shipping + cart.extras_total
        else
          cart.purchase_total + shipping + cart.extras_total
        end
      end

      protected

      def self.after_purchase_hook(purchase, user)

        site = Thread.current[:site]
        cxt = site.plugin_object_for_id('ecommerce').js3_context
        cxt['user'] = user
        cxt['purchase'] = purchase
        last = cxt.eval(Engine.config_or_default('after_purchase_hook'))
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
        :shipping, :tax, :tax_percentage, :total].each do |method|
        define_method("#{method.to_s}_value".to_sym) {@source.send(method).round(2)}
        define_method(method) {"%0.2f" % @source.send(method).round(2)}
        end

      delegate :cart, :stripe_token, :completed, :shipping_info, to: :@source

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
end
