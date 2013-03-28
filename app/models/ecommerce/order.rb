module Ecommerce
  class Order
    include Mongoid::Document
    include Mongoid::Timestamps
    field      :quantity,   :type => Integer, :default => 1 
    field      :product_id, :type => ::BSON::ObjectId
    belongs_to :cart,       :class_name => "::Ecommerce::Cart"

    def quantity=(value)
      begin
        new_quantity = Integer(value)
      rescue
        return false
      end
      self[:quantity] = new_quantity
      cart.remove_product_by_id(product_id) if new_quantity < 1
    end

    def quantity
      self[:quantity]
    end
    
    def product_sku
      i = product_class.where(:_id => product_id).first
      i == nil ? '' : i.sku
    end

    def product_price
      i = product_class.where(:_id => product_id).first
      i == nil ? 0 : i.price.to_f
    end

    def product_name
      i = product_class.where(:_id => product_id).first
      i == nil ? '' : i.description
    end

    def product_quantity
      i = product_class.where(:_id => product_id).first
      i == nil ? 0 : i.quantity
    end

    def product_quantity=(value)
      i = product_class.where(:_id => product_id).first
      i.quantity = value
      i.save!
    end

    def out_of_stock?
      quantity > product_quantity
    end

    private
    def product_class
      Inventory::InventoryItem
    end
  end
end
