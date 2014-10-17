require 'stripe'

module Locomotive
  module Ecommerce
    class PurchaseController < ::Locomotive::Ecommerce::ApplicationController
      before_filter :do_authorize, except: [:do_new_purchase]

      def create
        @purchase = current_user_cart(self).purchase
        @purchase.shipping_info = params[:shipping_info]
        @purchase.shipping_method = params[:shipping_method]
        if @purchase.save
          redirect_to confirm_order_path
          return
        elsif @purchase.errors.any?
          flash_ar = []
          @purchase.errors.full_messages.each { |msg| flash_ar << msg }
          flash[:error] = flash_ar.join(', ')
        end

        redirect_to checkout_path
      end

      def self.complete(purchase_id, user, cart, stripeToken)
        purchase = Purchase.where(_id: purchase_id).first

        #Reset user cart
        purchase.cart.user_id = nil
        purchase.cart.save!
        new_cart = Cart.create
        new_cart.user_id = user.id
        new_cart.save!

        #complete purchase
        purchase.stripe_token = stripeToken
        purchase.complete
        purchase.completed = true
        purchase.user_id = user.id
        purchase.save!
        PurchaseMailer.purchase_confirmation(user, purchase).deliver
        after_purchase_hook(purchase, user)
      end

      private

      def self.after_purchase_hook(purchase, user)

        site = Thread.current[:site]
        cxt = site.plugin_object_for_id('ecommerce').js3_context
        cxt['user'] = user
        cxt['purchase'] = purchase
        last = cxt.eval(Engine.config_or_default('after_purchase_hook'))
      end
      def do_authorize
        if Engine.config_or_default('require_user')
          authenticate_user!
        end
      end
    end
  end
end
