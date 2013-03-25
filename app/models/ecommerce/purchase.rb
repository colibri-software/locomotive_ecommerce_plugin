module Ecommerce
  class Purchase
    include Mongoid::Document
    include Mongoid::Timestamps
    field   :shipping_info, :type => String
    field   :billing_info,  :type => String
    field   :completed,     :type => Boolean, :default => false
    field   :amount,        :type => Float
    field   :user_id,       :type => ::BSON::ObjectId
    has_one :cart,          :class_name => "::Ecommerce::Cart"
    
    validates_presence_of :shipping_info, :billing_info
  end
end
