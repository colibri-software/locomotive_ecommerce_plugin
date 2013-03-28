module Ecommerce
  class ApplicationController < ActionController::Base
    helper_method :authenticate_user!, :locomotive_user?

    def authenticate_user!
      if current_user == nil
        flash[:error] = "Authentication needed.  Please log in to continue."
        redirect_to root_path
      end
    end

    def locomotive_user?
      locomotive_account_signed_in?
    end

    # TO FIX: USER STUFF
    helper_method :current_user

    def current_user
      @current_user ||= IdentityEngine::User.find(session[:user_id]) if session[:user_id]
    end


    # TO FIX: CART STUFF
    helper_method :current_user_cart

    def current_user_cart
      id = current_user == nil ? nil : current_user.id
      Cart.find_or_create(id, session)
    end


    # TO FIX: ITEMS
    helper_method :inventory_items

    def inventory_items
      Inventory::InventoryUpdate.stable.inventory_items
    end


    # TO FIX: HARDCODED PATHS
    helper_method :login_path, :logout_path

    def login_path
      '/locomotive/plugins/identity_plugin/login'
    end

    def logout_path
      '/locomotive/plugins/identity_plugin/logout'
    end


    # TO FIX: name/price in order.rb
  end
end
