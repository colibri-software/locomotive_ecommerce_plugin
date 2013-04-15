module Ecommerce
  module EcommercePurchaseHelper
    def do_purchase_new(path, controller)
      if current_user(controller) == nil
        controller.flash[:info] = 'Please login or sign up to continue.'
        controller.redirect_to cart_path
      else
        controller.redirect_to cart_path if !current_user_cart(controller).valid_stock?
        purchase = Purchase.new
        purchase.amount = current_user_cart(controller).get_total
        controller.render_cell 'ecommerce/purchase', :new,
          purchase: purchase, url: self, stem: path
      end
    end

    def do_purchase(purchase_id, path, controller)
      purchase = Purchase.find(purchase_id)
      cart = purchase.completed ? purchase.cart : current_user_cart(controller)
      controller.render_cell 'ecommerce/purchase', :show,
        purchase: purchase, cart: cart, url: self, stem: path
    end

    def do_purchases(controller)
      purchases = Purchase.where(:user_id => current_user(controller).id)
      controller.render_cell 'ecommerce/purchase', :index,
        purchases: purchases, url: self
    end
  end
end
