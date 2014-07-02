module HbirdEcommerce
  class PurchaseMailer < ActionMailer::Base
    default from: Engine.config_or_default('contact')
  
    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.purchase_mailer.purchase_confirmation.subject
    #
    def purchase_confirmation(user, purchase)
      @purchase = purchase
      @contact = Engine.config_or_default('contact')
      @shop_name = Engine.config_or_default('shop_name')
      mail to: user.email, subject: "Purchase Confirmation"
    end
  end
end
