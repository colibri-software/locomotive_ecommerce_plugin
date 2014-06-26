module HbirdEcommerce
  class Cart
    include Mongoid::Document
    field      :user_id,     :type => ::BSON::ObjectId
    belongs_to :purchase,    :class_name => "::HbirdEcommerce::Purchase"
    has_many   :orders,      :class_name => "::HbirdEcommerce::Order"

    def add_product_by_id(product_id)
      sku = Order.id_to_sku(product_id)
      already_existing_order = orders.where(:sku => sku)
      if already_existing_order.count > 0
        order = already_existing_order.first
        order.quantity += 1
      else
        order = Order.new
        order.sku = sku
        order.cart = self  
      end
      order.save!
      return order
    end

    def remove_product_by_id(product_id)
      sku = Order.id_to_sku(product_id)
      order = orders.where(:sku => sku)
      order.destroy if order
    end

    def purchase_total
      total = 0
      orders.each { |order| total += order.price }
      return total
    end

    def estimated_tax
      purchase_total * ((Engine.config_or_default('estimated_tax_rate').to_f/100))
    end

    def subtotal_est_tax
      purchase_total + estimated_tax
    end

    def update_from_params(params)
      to_update = Order.find(params[:order_ids])
      count = 0
      to_update.each do |order|
        order.quantity = params[:quantity_ids][count] if order.cart_id == id
        count += 1
        order.save!
      end
    end

    # merge in contents of another cart
    def merge(cart)
      cart.orders.each do |order|
        (1..order.quantity).each { |c| add_product_by_id(order.product.id) }
        cart.remove_product_by_id(order.product.id)
      end
    end

    def valid_stock?
      orders.each { |order| return false if order.out_of_stock? }
      return true
    end

    def to_liquid
      CartDrop.new(self)
    end

    # self methods
    def self.for_user(id)
      cart = where(:user_id => id).first || create(:user_id => id)
    end

    def self.find_or_create(id, session)
      cart_id = session[:cart_id]
      if cart_id != nil
        cart = where(:_id => cart_id).first

        if cart == nil
          session[:cart_id] = nil
          return find_or_create(id, session)
        end

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

  class CartDrop < ::Liquid::Drop
    def initialize(source)
      @source = source
    end

    def line_items
      @source.orders
    end

    def id
      @source.id.to_s
    end

    [:purchase_total, :estimated_tax, :subtotal_est_tax].each do |method|
      define_method(method) {@source.send(method).round(2)}
    end

    delegate :valid_stock?, to: :@source

    protected
    attr_accessor :source
  end
end
