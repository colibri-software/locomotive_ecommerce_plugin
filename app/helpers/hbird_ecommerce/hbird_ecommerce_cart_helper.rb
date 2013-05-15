module HbirdEcommerce
  module HbirdEcommerceCartHelper
    def do_cart(path, controller)
      cart = current_user_cart(controller)
      if !cart.valid_stock?
        controller.flash[:error] =
          Engine.config_or_default('cart_error')
      end
      controller.render_cell 'hbird_ecommerce/cart_page', :show,
        cart: cart, url: self, stem: path
    end

    def do_cart_update(params, controller)
      @cart = Cart.find(params[:id])
      @cart.update_from_params(params)
      controller.flash[:success] = 'Updated cart'
      controller.redirect_to cart_path
    end

    def current_user_cart(controller)
      user = current_user(controller)
      id = user == nil ? nil : user.id
      Cart.find_or_create(id, controller.session)
    end
  end
end