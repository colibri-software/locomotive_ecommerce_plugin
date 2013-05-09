module HbirdEcommerce
  module HbirdEcommerceOrderHelper
    def do_order_create(params, controller)
      @order = current_user_cart(controller).add_product_by_id(params[:product_id])
      controller.flash[:success] = 'Added product to cart'
      controller.redirect_to cart_path
    end

    def do_order_destroy(params, controller)
      @order = current_user_cart(controller).remove_product_by_id(
        params[:product_id])
      controller.flash[:success] = 'Removed product from cart'
      controller.redirect_to cart_path
    end
  end
end
