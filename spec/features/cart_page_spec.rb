require 'spec_helper'

class FakeUser
  include Mongoid::Document
  field :name

  def cart
    Ecommerce::Cart.for_user(id)
  end

  def purchases
    Ecommerce::Purchase.where(:user_id => id)
  end
end

module Ecommerce
  describe "Cart pages" do

    # Not logged in
    describe "when the user isn't signed in" do
      it "should have a view cart link" do
        ApplicationController.any_instance.stub(:inventory_items).and_return([])
        visit main_app.root_path
        page.should have_link('Cart ($0)')
      end

      it "should have an add to cart link on the product page" do
        product = fake_product
        visit main_app.product_path(product)
        page.should have_button('Add to Cart')
      end

      it "should allow viewing of a cart" do
        ApplicationController.any_instance.stub(:inventory_items).and_return([])
        visit main_app.cart_path
        page.should have_content('cart is currently empty')
      end
    end

    # Logged in
    describe "when the user is signed in" do
      before do
        @user = login
        @product = fake_product
      end

      it "should have a view cart link" do
        visit main_app.root_path
        page.should have_link('Cart ($0)')
      end

      it "should have an add to cart link on the product page" do
        visit main_app.product_path(@product)
        page.should have_button('Add to Cart')
      end

      describe "when the product isn't already in the cart" do
        it "add to cart should increase the number of orders in the cart by one" do
          visit main_app.product_path(@product)
          expect { find_button('Add to Cart').click }.to change(@user.cart.orders, :count).by(1)
        end

        it "shouldn't be able to checkout" do
          visit main_app.cart_path
          page.should_not have_button('Checkout')
        end
      end

      describe "when the product is already in the cart" do
        before do
          expect { add_product }.to change(@user.cart.orders, :count).by(1)
        end

        it "add to cart should not increase the number of orders in the cart" do
          expect { add_product }.not_to change(@user.cart.orders, :count)
        end

        it "remove from cart should decrease the number of orders in the cart by one" do
          visit main_app.cart_path
          @user.cart.orders.count.should == 1
          expect { find_link('Remove').click }.to change(@user.cart.orders, :count).by(-1)
        end

        it "update should change the quantity" do
          visit main_app.cart_path
          find(:css, "input[id$='quantity_ids_']").set("10")
          old_quantity = @user.cart.orders.first.quantity
          find_button('Update').click
          new_quantity = @user.cart.orders.first.quantity
          new_quantity.should_not equal old_quantity
        end

        it "updating with a quantity less than 1 should remove the item" do
          visit main_app.cart_path
          find(:css, "input[id$='quantity_ids_']").set("0")
          find_button('Update').click
          @user.cart.orders.count.should equal 0
        end
      end

      describe "during checkout" do
        before do
          add_product
          visit main_app.cart_path
          find_button('Checkout').click
        end

        it "shouldn't move forward if the user doesn't accept the TOS" do
          set_field_by_id('purchase_shipping_info', 'non-empty')
          set_field_by_id('purchase_billing_info', 'also non-empty')
          find_button('Purchase').click
          page.should have_button('Purchase')
          page.should have_content('agree to the terms of service')
        end

        it "shouldn't move forward if the shipping info is blank" do
          set_field_by_id('purchase_billing_info', 'non-empty')
          set_field_by_id('tos', true)
          find_by_id('tos').click
          find_button('Purchase').click
          page.should have_button('Purchase')
          page.should have_content("Shipping info can't be blank")
        end

        it "shouldn't move forward if the billing info is blank" do
          set_field_by_id('purchase_shipping_info', 'non-empty')
          set_field_by_id('tos', true)
          find_button('Purchase').click
          page.should have_button('Purchase')
          page.should have_content("Billing info can't be blank")
        end
      end

      describe "after checkout" do
        before do
          add_product
          visit main_app.cart_path
          find_button('Checkout').click
          set_field_by_id('purchase_shipping_info', 'non-empty')
          set_field_by_id('purchase_billing_info', 'also non-empty')
          set_field_by_id('tos', true)
          find_button('Purchase').click
          new_q = @product.quantity - 1
          @product.should_receive(:quantity=).with(new_q).and_return(true)
        end

        it "should have content thanking the user for their purchase", js: true do
          click_button('Pay with Card')
          page.within_frame 0 do
            fill_in 'paymentNumber',  with: '4242424242424242'
            fill_in 'paymentExpiry',  with: '5/16'
            fill_in 'paymentName',    with: 'test card holder'
            fill_in 'paymentCVC',     with: '123'
            click_button 'Pay'
            page.should have_content('Thank you for your purchase')
          end
        end

        it "there should be a cart attached to the last purchase", js: true do
          click_button('Pay with Card')
          page.within_frame 0 do
            fill_in 'paymentNumber',  with: '4242424242424242'
            fill_in 'paymentExpiry',  with: '5/16'
            fill_in 'paymentName',    with: 'test card holder'
            fill_in 'paymentCVC',     with: '123'
            click_button 'Pay'

            page.should have_content('Thank you for your purchase')
            Purchase.count.should == 1
            Purchase.last.cart.orders.count.should == 1
            Purchase.last.cart.get_total.should == @product.price.to_f
          end
        end

        it "the user's cart should be empty", js: true do
          click_button('Pay with Card')
          page.within_frame 0 do
            fill_in 'paymentNumber',  with: '4242424242424242'
            fill_in 'paymentExpiry',  with: '5/16'
            fill_in 'paymentName',    with: 'test card holder'
            fill_in 'paymentCVC',     with: '123'
            click_button 'Pay'

            page.should have_content('Thank you for your purchase')
            @user.reload
            @user.cart.orders.count.should == 0
          end
        end

        it "the user's purchases should increase by one", js: true do
          expect do
            click_button('Pay with Card')
            page.within_frame 0 do
              fill_in 'paymentNumber',  with: '4242424242424242'
              fill_in 'paymentExpiry',  with: '5/16'
              fill_in 'paymentName',    with: 'test card holder'
              fill_in 'paymentCVC',     with: '123'
              click_button 'Pay'

              page.should have_content('Thank you for your purchase')
              @user.reload
            end
          end.to change(@user.purchases, :count).by(1)
        end
      end
    end

    describe "cart merging" do
      it "merges carts when the user signs in" do
        product = fake_product
        visit main_app.root_path
        guest_cart = Cart.first
        guest_cart.orders.count.should == 0
        visit main_app.product_path(product)
        find_button('Add to Cart').click
        guest_cart.orders.count.should == 1

        user = login
        user_cart = Cart.for_user(user.id)
        user_cart.orders.count.should == 1
        Cart.count.should == 1
        Cart.first.should == user_cart
      end
    end

    # Helpers
    protected
    def login
      user = FakeUser.create(:name => 'test')
      ::ApplicationController.subclasses.each do |controller|
        controller.any_instance.stub(:current_user).with(any_args()).and_return(user)
      end
      ApplicationController.any_instance.stub(
        :current_user).with(any_args()).and_return(user)
      StripeConfigurationHelper.any_instance.stub(:current_user).and_return(user)
      visit main_app.cart_path
      return user
    end

    def another_login
      another = FakeUser.create(:name => 'another')
      return another
    end

    def fake_product
      product = mock_model 'Product',
        sku:         'test sku',
        description: 'test desc',
        price:       '50.0',
        picture:     '',
        id:          BSON::ObjectId.new
      product.stub(:where).and_return(product)
      product.stub(:first).and_return(product)
      product.stub(:quantity).and_return(100)
      product.stub(:save!).and_return(true)
      TestController.any_instance.stub(:inventory_items).and_return(product)
      Order.stub(:product_class).and_return(product)
      Remote::Order.stub(:create).and_return(true)
      return product
    end

    def add_product
      visit main_app.product_path(@product)
      find_button('Add to Cart').click
    end

    def set_field_by_id(id, value)
      find(:css, "input[id$='#{id}']").set(value)
    end
  end
end
