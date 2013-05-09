require 'stripe'

module HbirdEcommerce
  class PurchaseController < ::HbirdEcommerce::ApplicationController
    before_filter :authenticate_user!, except: [:do_new_purchase]

    def create
      @purchase = Purchase.new(params[:purchase])
      @purchase.amount = current_user_cart(self).get_total
      if params[:tos] != "yes"
        flash[:error] = 'To complete the purchase, please agree ' +
          'to the terms of service.'
      elsif @purchase.save
        redirect_to checkout_path(@purchase)
        return
      elsif @purchase.errors.any?
        flash_ar = []
        @purchase.errors.full_messages.each { |msg| flash_ar << msg }
        flash[:error] = flash_ar.join(', ')
      end

      redirect_to new_checkout_path
    end

    def self.complete(purchase_id, user, cart, stripeToken)
      @purchase = Purchase.where(_id: purchase_id).first
      @purchase.cart = cart
      @purchase.cart.user_id = nil
      @purchase.stripe_token = stripeToken
      @purchase.complete

      new_cart = Cart.create
      new_cart.user_id = user.id
      new_cart.save!

      @purchase.cart.save!
      @purchase.completed = true
      @purchase.user_id = user.id
      @purchase.save!
      send_purchase(@purchase)
    end

    def push
      if !locomotive_user?
        redirect_to :back
        return
      end
      to_send = Purchase.where(:completed => true, :transmitted => false)
      to_send.each { |send| self.class.send_purchase(send) }
      flash[:notice] = "Pushing orders."
      redirect_to :back
    end

    private
    def self.send_purchase(send)
      summary = {}
      send.cart.orders.each do |order|
        summary[order.product_sku] = order.quantity
      end
      order = Class.new(Remote::Order) do
        self.site = Engine.config_or_default('app_url')
      end
      order.create(
        shipping_info: send.shipping_info,
        billing_info:  send.billing_info,
        summary:       summary
      )
      send.transmitted = true
      send.save!
    end
  end
end
