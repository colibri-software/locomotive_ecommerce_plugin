module Ecommerce
  class ProductsController < ApplicationController
    def index
      @products = inventory_items
    end

    def show
      @product = inventory_items.where(:_id => params[:id]).first
    end
  end
end
