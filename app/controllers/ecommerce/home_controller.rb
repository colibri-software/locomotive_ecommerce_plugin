module Ecommerce
  class HomeController < ApplicationController
    def index
      @items = inventory_items
    end
  end
end
