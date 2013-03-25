module Ecommerce
  class CartController < ApplicationController
    before_filter :authenticate_user!
    def show
      @cart = Cart.find(params[:id])
      redirect_to root_path if current_user_cart != @cart
    end

    def update
      orders = Order.find(params[:order_ids])
      count = 0
      orders.each do |order|
        order.quantity = params[:quantity_ids][count]
        count += 1
        order.save!
      end
      flash_me(:success, 'Updated cart')
      redirect_to cart_path(current_user_cart)
    end
  end
end
