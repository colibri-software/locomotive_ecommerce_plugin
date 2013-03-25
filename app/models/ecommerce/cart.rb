module Ecommerce
  class Cart
    include Mongoid::Document
    field      :user_id,     :type => ::BSON::ObjectId
    belongs_to :purchase,    :class_name => "::Ecommerce::Purchase"
    has_many   :orders,      :class_name => "::Ecommerce::Order"

    def self.for_user(id)
      cart = where(:user_id => id).first
      if cart == nil
        cart = create
        cart.user_id = id
        cart.save!
      end
      cart
    end

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
  end
end
