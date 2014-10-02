require 'stripe'
require 'stripe_helper'

module Locomotive
  module Ecommerce
    class StripeConfigurationHelper
      include EcommerceHelper
    end

    ::StripeHelper.configure do |config|
      helper = StripeConfigurationHelper.new

      amt_proc = lambda do |controller, token|
        purchase = Purchase.where(_id: token).first
        return nil if !purchase
        (purchase.total.round(2)*100).to_i
      end

      failure_proc = lambda do |controller, token, msg|
        purchase = Purchase.where(_id: token).first
        controller.flash[:error] = msg
        helper.checkout_path
      end

      success_proc = lambda do |controller, token, stripe|
        purchase = Purchase.where(_id: token).first
        PurchaseController.complete(token,
                                    helper.current_user(controller),
                                    helper.current_user_cart(controller),
                                    stripe)
        controller.flash[:notice] = "Thank you for your purchase."
        helper.post_checkout_path
      end

      config.charge_amount  = amt_proc
      config.charge_failure = failure_proc
      config.charge_success = success_proc
    end
  end
end