module Ecommerce
  class Cart
    include Mongoid::Document
    field      :user_id,     :type => ::BSON::ObjectId
    belongs_to :purchase,    :class_name => "::Ecommerce::Purchase"
    has_many   :orders,      :class_name => "::Ecommerce::Order"

    def add_product_by_id(product_id)
      already_existing_order = orders.where(:product_id => product_id)
      if already_existing_order.count > 0
        order = already_existing_order.first
        order.quantity += 1
      else
        order = Order.new
        order.product_id = product_id
        order.cart = self  
      end
      order.save!
      return order
    end

    def remove_product_by_id(product_id)
      order = orders.where(:product_id => product_id)
      order.destroy if order
    end

    def get_total
      total = 0
      orders.each { |order| total += order.quantity * order.product_price }
      return total
    end

    # merge in contents of another cart
    def merge(cart)
      cart.orders.each do |order|
        (1..order.quantity).each { |c| add_product_by_id(order.product_id) }
        cart.remove_product_by_id(order.product_id)
      end
    end

    # self methods
    def self.for_user(id)
      cart = where(:user_id => id).first || create(:user_id => id)
    end

    def self.find_or_create(id, session)
      cart_id = session[:cart_id]
      if cart_id != nil
        cart = where(:_id => cart_id).first
        return cart if id == nil

        session[:cart_id] = nil
        user_cart = Cart.for_user(id)
        user_cart.merge(cart)
        cart.destroy
        return user_cart
      end

      return Cart.for_user(id) if id != nil
        
      cart = create
      cart.save!
      session[:cart_id] = cart.id.to_s
      return cart
    end
  end
end
