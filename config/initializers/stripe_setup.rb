require 'stripe'
require 'stripe_helper'

::Stripe.api_key = 'sk_test_X9DCHXrX0Siun6NdVJu9uu13'
module Ecommerce
  class StripeConfigurationHelper
    include EcommerceHelper
  end

  ::StripeHelper.configure do |config|
    helper = StripeConfigurationHelper.new

    amt_proc = lambda do |controller, token|
      purchase = Purchase.where(_id: token).first
      return nil if !purchase
      amt_check = helper.current_user_cart(controller).get_total
      purchase.amount == amt_check ? amt_check.round(2).to_i * 100 : nil
    end

    failure_proc = lambda do |controller, token, msg|
      purchase = Purchase.where(_id: token).first
      controller.flash[:error] = msg
      helper.checkout_path(purchase)
    end

    success_proc = lambda do |controller, token, stripe|
      purchase = Purchase.where(_id: token).first
      PurchaseController.complete(token,
                                  helper.current_user(controller),
                                  helper.current_user_cart(controller),
                                  stripe)
      controller.flash[:notice] = "Thank you for your purchase."
      helper.checkout_path(purchase)
    end

    config.charge_amount  = amt_proc
    config.charge_failure = failure_proc
    config.charge_success = success_proc
    config.public_key     = 'pk_test_wx56SSu3dclTN60p9rEGcM7n'
  end
end
