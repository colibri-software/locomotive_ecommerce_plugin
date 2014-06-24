require 'stripe'

module HbirdEcommerce
  class PurchaseController < ::HbirdEcommerce::ApplicationController
    before_filter :authenticate_user!, except: [:do_new_purchase]

    def create
      @purchase = current_user_cart(self).purchase
      @purchase.shipping_info = params[:shipping_info]
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
      @purchase = Purchase.where(_id: purchase_id).first

      #Reset user cart
      @purchase.cart.user_id = nil
      @purchase.cart.save!
      new_cart = Cart.create
      new_cart.user_id = user.id
      new_cart.save!

      #complete purchase
      @purchase.stripe_token = stripeToken
      @purchase.complete
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

    def self.send_purchase(purchase)
      summary = {}
      purchase.cart.orders.each do |order|
        summary[order.product_sku] = order.quantity
      end
      puts "---------------------------"
      puts purchase.shipping_info
      puts "---------------------------"
      Remote::Order.create(
        shipping_info: purchase.shipping_info,
        summary:       summary
      )
      purchase.transmitted = true
      purchase.save!
    end
  end
end
