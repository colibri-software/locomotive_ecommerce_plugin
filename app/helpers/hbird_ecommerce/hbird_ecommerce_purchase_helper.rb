module HbirdEcommerce
  module HbirdEcommercePurchaseHelper
    def do_purchase_new(path, controller)
      if current_user(controller) == nil
        controller.session[:needs_login] = true
        controller.redirect_to cart_path
      else
        controller.redirect_to cart_path if !current_user_cart(controller).valid_stock?
        purchase = Purchase.new
        purchase.amount = current_user_cart(controller).get_total
        controller.render_cell 'hbird_ecommerce/purchase', :new,
          purchase: purchase, url: self, stem: path
      end
    end

    def do_purchase(purchase_id, path, controller)
      purchase = Purchase.find(purchase_id)
      cart = purchase.completed ? purchase.cart : current_user_cart(controller)
      controller.render_cell 'hbird_ecommerce/purchase', :show,
        purchase: purchase, cart: cart, url: self, stem: path
    end

    def do_purchases(controller)
      user = current_user(controller)
      if user == nil
        controller.redirect_to cart_path
      else
        purchases = Purchase.where(:user_id => user.id)
        controller.render_cell 'hbird_ecommerce/purchase', :index,
          purchases: purchases, url: self
      end
    end
  end
end
