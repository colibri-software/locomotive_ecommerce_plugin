require 'spec_helper'

module Locomotive
  module Ecommerce
    describe "Products pages" do
      let!(:mocks) { mocks = mock_products }

      before(:each) do
        TestController.any_instance.stub(:inventory_items).and_return(mocks)
      end

      it 'displays products' do
        visit main_app.products_path
        page.should have_content('test desc')
        page.should have_content('another desc')
      end

      context 'filtering' do
        it 'allows sku matching' do
          set_params({'sku' => 'test'})
          mocks.should_receive(:and).with(sku: /test/i).and_return(
            paginate_array [mocks[0]])
          visit main_app.products_path
          page.should have_content('test desc')
          page.should_not have_content('another desc')
        end

        it 'allows asc sorting' do
          set_params({'sku_sort' => 'asc'})
          mocks.should_receive(:asc).with(:sku).and_return(
            paginate_array mocks.reverse)
          visit main_app.products_path
        end

        it 'allows desc sorting' do
          set_params({'price_sort' => 'desc'})
          mocks.should_receive(:desc).with(:product_price).and_return(
            paginate_array mocks.reverse)
          visit main_app.products_path
        end

        it 'allows a maximum' do
          set_params({'quantity_max' => 6})
          mocks.should_receive(:and).with(:quantity.lt => 6).and_return(
            paginate_array [mocks[0]])
          visit main_app.products_path
          page.should have_content('test desc')
          page.should_not have_content('another desc')
        end

        it 'allows a minimum' do
          set_params({'quantity_min' => 6})
          mocks.should_receive(:and).with(:quantity.gt => 6).and_return(
            paginate_array [mocks[1]])
          visit main_app.products_path
          page.should_not have_content('test desc')
          page.should have_content('another desc')
        end
      end

      protected
      def set_params(params)
        TestController.any_instance.stub(:products_params).and_return(params)
      end

      def mock_products
        product_1 = mock_model 'Product',
          sku:         'test sku',
          description: 'test desc',
          price:       '50.0',
          picture:     '',
          quantity:    5,
          id:          BSON::ObjectId.new,
          thumbnail:   ''
        product_2 = mock_model 'Product',
          sku:         'second sku',
          description: 'another desc',
          price:       '4321.0',
          quantity:    10,
          picture:     '',
          id:          BSON::ObjectId.new,
          thumbnail:   ''
        paginate_array [product_1, product_2]
      end

      def paginate_array(array)
        array.stub(:page).and_return(Kaminari.paginate_array(array).page)
        array
      end
    end
  end
end