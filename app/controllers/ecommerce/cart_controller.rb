module Ecommerce
  class CartController < ApplicationController
    def show
      @cart = Cart.find(params[:id])
      redirect_to root_path if current_user_cart != @cart
    end

    def update
      @cart = Cart.find(params[:id])
      @cart.update_from_params(params)
      flash_me(:success, 'Updated cart')
      redirect_to cart_path(current_user_cart)
    end
  end
end
