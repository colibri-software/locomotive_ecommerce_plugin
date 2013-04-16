class TestController < ApplicationController
  before_filter :render_flash

  def render_flash
    @flash_text = render_cell 'ecommerce/flash', :show, flash: flash 
  end

  ###############
  # plugin pages
  ###############
  def show_cart
    render :text => @flash_text + do_cart('/', self)
  end

  def new_checkout
    render :text => @flash_text + do_purchase_new('/', self)
  end

  def show_checkout
    @purchase = Ecommerce::Purchase.find(params[:p])
    render :text => @flash_text + do_purchase(@purchase.id, '/', self)
  end

  def index_purchases
    @purchases = Ecommerce::Purchase.where(:user_id => current_user.id)
    render :text => @flash_text + do_purchases(self)
  end
  
  def index_products
    @products = inventory_items
    render :text => @flash_text + do_products({}, '/', self)
  end

  def show_product
    @product = inventory_items.where(:_id => params[:id]).first
    render :text => @flash_text + do_product(@product.id, '/', self)
  end
end
