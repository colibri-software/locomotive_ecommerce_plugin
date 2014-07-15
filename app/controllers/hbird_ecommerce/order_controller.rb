module HbirdEcommerce
  class OrderController < ::HbirdEcommerce::ApplicationController
    def create
      @order = current_user_cart(self).add_product_by_sku(params[:item_sku])
      flash[:success] = 'Added product to cart'
      redirect_to cart_path
    end

    def destroy
      @order = current_user_cart(self).remove_product_by_sku(
        params[:product_id])
      flash[:success] = 'Removed product from cart'
      redirect_to cart_path
    end
  end
end
