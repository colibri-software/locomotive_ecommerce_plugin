module Ecommerce
  class ApplicationController < ActionController::Base

    # HARDCODED FOR NOW
    helper_method :current_user, :login_path, :logout_path, :inventory_items,
      :current_user_cart, :authenticate_user!

    def current_user
      @current_user ||= IdentityEngine::User.find(session[:user_id]) if session[:user_id]
    end

    def login_path
      '/locomotive/plugins/identity_plugin/login'
    end

    def logout_path
      '/locomotive/plugins/identity_plugin/logout'
    end

    def current_user_cart
      # @cart ||= Cart.for_user(current_user.id)
      Cart.for_user(current_user.id) if current_user
    end

    def inventory_items
      Inventory::InventoryUpdate.stable.inventory_items
    end

    # also name/price in order.rb 
    
    def authenticate_user!
      if current_user == nil
        flash[:error] = "Authentication needed.  Please log in to continue."
        redirect_to root_path
      end
    end

  end
end
