require 'stripe'

module Locomotive
  module Ecommerce
    class PurchaseController < ::Locomotive::Ecommerce::ApplicationController
      before_filter :do_authorize, except: [:do_new_purchase]

      def create
        @purchase = current_user_cart(self).purchase
        @purchase.shipping_info = params[:shipping_info]
        @purchase.shipping_method = params[:shipping_method]
        if @purchase.save
          redirect_to confirm_order_path
          return
        elsif @purchase.errors.any?
          flash_ar = []
          @purchase.errors.full_messages.each { |msg| flash_ar << msg }
          flash[:error] = flash_ar.join(', ')
        end

        redirect_to checkout_path
      end

      private

      def do_authorize
        if Engine.config_or_default('require_user')
          authenticate_user!
        end
      end
    end
  end
end
