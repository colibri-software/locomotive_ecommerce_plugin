module Ecommerce
  class OrderController < ApplicationController
    def create
      @order = current_user_cart.add_product_by_id(params[:product_id])
      flash_me(:success, 'Added product to cart')
      redirect_to cart_path(current_user_cart) 
    end

    def destroy
      @order = current_user_cart.remove_product_by_id(params[:product_id])
      flash_me(:success, 'Removed product from cart')
      redirect_to cart_path(current_user_cart)
    end
  end
end
