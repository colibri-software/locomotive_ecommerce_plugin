class ApplicationController < ActionController::Base
  protect_from_forgery
  include ::HbirdEcommerce::HbirdEcommerceHelper
  helper_method :current_user, :current_user_cart, :login_path, :logout_path

  def current_user(*args)
    args && args.size > 0 ? super(args.first) : super(self)
  end

  def current_user_cart(*args)
    args && args.size > 0 ? super(args.first) : super(self)
  end

  def login_path
    '/login'
  end

  def logout_path
    '/logout'
  end
end
