module Locomotive
  module Ecommerce
    module InventoryInterface
      # Inventory
      def inventory_items
        site = Thread.current[:site]
        site.plugin_object_for_id('inventory').js3_context.eval(Engine.config_or_default('shop_inventory_update'))
      end
    end
  end
end
