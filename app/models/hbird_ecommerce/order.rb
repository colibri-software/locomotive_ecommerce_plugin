module HbirdEcommerce
  class Order
    include Mongoid::Document
    include Mongoid::Timestamps
    field      :quantity,   :type => Integer, :default => 1 
    field      :sku,        :type => String
    belongs_to :cart,       :class_name => "::HbirdEcommerce::Cart"

    def quantity=(value)
      begin
        new_quantity = Integer(value)
      rescue
        return false
      end
      self[:quantity] = new_quantity
      cart.remove_product_by_id(product.id) if new_quantity < 1
    end

    def quantity
      self[:quantity]
    end
    
    def product_sku
      i = product
      i == nil ? '' : i.sku
    end

    def product_price
      i = product
      i == nil ? 0 : i.price.to_f
    end

    def product_name
      i = product
      i == nil ? '' : i.description
    end

    def product_quantity
      i = product
      i == nil ? 0 : i.quantity
    end

    def product_quantity=(value)
      i = product
      i.quantity = value
      i.save!
    end

    def out_of_stock?
      quantity > product_quantity
    end

    def self.id_to_sku(id)
      ret = product_class.where(:_id => id).first
      ret ? ret.sku : nil
    end

    def product
      self.class.product_class.where(:sku => sku).first
    end

    private
    def self.product_class
      HbirdInventory::InventoryItem
    end
  end
end