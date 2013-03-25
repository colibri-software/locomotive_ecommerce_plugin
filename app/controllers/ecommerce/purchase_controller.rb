module Ecommerce
  class PurchaseController < ApplicationController
    before_filter :authenticate_user!

    def new
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

      new_cart = Cart.create
      new_cart.user_id = current_user.id
      new_cart.save!

      @purchase.cart.save!
      @purchase.completed = true
      @purchase.user_id = current_user.id
      @purchase.save!
      flash[:notice] = "Thank you for your purchase."
      redirect_to checkout_path(@purchase)
    end

    def index
      @purchases = Purchase.where(:user_id => current_user.id)
    end
  end
end
