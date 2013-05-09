module HbirdEcommerce
  class ApplicationController < ActionController::Base
    include ::HbirdEcommerce::HbirdEcommerceHelper

    def authenticate_user!
      if current_user(self) == nil
        flash[:error] = "Authentication needed.  Please log in to continue."
        redirect_to cart_path
      end
    end

    def locomotive_user?
      locomotive_account_signed_in?
    end
  end
end
