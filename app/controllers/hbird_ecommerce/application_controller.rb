module HbirdEcommerce
  class ApplicationController < ActionController::Base
    include ::HbirdEcommerce::HbirdEcommerceHelper

    before_filter :set_current_site

    def authenticate_user!
      if current_user(self) == nil
        flash[:error] = "Authentication needed.  Please log in to continue."
        redirect_to cart_path
      end
    end

    def locomotive_user?
      locomotive_account_signed_in?
    end

    private

    def fetch_site
      if Locomotive.config.multi_sites?
        @current_site ||= Locomotive::Site.match_domain(request.host).first
      else
        @current_site ||= Locomotive::Site.first
      end
    end

    def set_current_site
      Thread.current[:site] = fetch_site
    end

  end
end
