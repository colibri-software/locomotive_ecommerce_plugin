module Ecommerce
  class PurchaseController < ApplicationController
    before_filter :authenticate_user!

    def new
      redirect_to cart_path(current_user_cart) if !current_user_cart.valid_stock?
      @purchase = Purchase.new
      @purchase.amount = current_user_cart.get_total
    end

    def create
      @purchase = Purchase.new(params[:purchase])
      @purchase.amount = current_user_cart.get_total
      if params[:tos] != "yes"
        flash_me_now(:error, 'To complete the purchase, please agree ' +
                     'to the terms of service.')
      elsif @purchase.save
        redirect_to checkout_path(@purchase)
        return
      elsif @purchase.errors.any?
        @purchase.errors.full_messages.each { |msg| flash_me_now(:error, msg) }
      end
      render 'new'
    end

    def show
      @purchase = Purchase.find(params[:id])
    end

    def update
      @purchase = Purchase.find(params[:id])
      @purchase.cart = current_user_cart
      @purchase.cart.user_id = nil
      @purchase.complete

      new_cart = Cart.create
      new_cart.user_id = current_user.id
      new_cart.save!

      @purchase.cart.save!
      @purchase.completed = true
      @purchase.user_id = current_user.id
      @purchase.save!
      send_purchase(@purchase)
      flash[:notice] = "Thank you for your purchase."
      redirect_to checkout_path(@purchase)
    end

    def index
      @purchases = Purchase.where(:user_id => current_user.id)
    end

    def push
      if !locomotive_user?
        redirect_to root_path
        return
      end
      to_send = Purchase.where(:completed => true, :transmitted => false)
      to_send.each { |send| send_purchase(send) }
      flash[:notice] = "Pushing orders."
      redirect_to :back
    end

    private
    def send_purchase(send)
      summary = {}
      send.cart.orders.each do |order|
        summary[order.product_sku] = order.quantity
      end
      Remote::Order.create(
        shipping_info: send.shipping_info,
        billing_info:  send.billing_info,
        summary:       summary
      )
      send.transmitted = true
      send.save!
    end
  end
end
