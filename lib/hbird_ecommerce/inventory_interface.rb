module HbirdEcommerce
  module InventoryInterface
    # Inventory
    def inventory_items
      if Engine.config_or_default('with_quantity')
        HbirdInventory::InventoryUpdate.stable.inventory_items.where(:quantity.gt => 0)
      else
        HbirdInventory::InventoryUpdate.stable.inventory_items
      end
    end
  end
end
