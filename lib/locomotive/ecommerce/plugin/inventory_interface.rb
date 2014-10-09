module Locomotive
  module Ecommerce
    module InventoryInterface
      # Inventory
      def inventory_items
        site = Thread.current[:site]
        site.plugin_object_for_id('inventory').js3_context.eval(Engine.config_or_default('shop_inventory_update'))
      end
      def inventory_items_class
        site = Thread.current[:site]
        site.plugin_object_for_id('inventory').js3_context.eval(Engine.config_or_default('shop_inventory_items'))
      end
    end
  end
end
