module HbirdEcommerce
  class CartController < ::HbirdEcommerce::ApplicationController
    def update
      @cart = Cart.find(params[:id])
      @cart.update_from_params(params)
      flash[:success] = 'Updated cart'
      redirect_to cart_path
    end
  end
end
