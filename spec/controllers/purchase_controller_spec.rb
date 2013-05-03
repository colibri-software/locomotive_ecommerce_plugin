require 'spec_helper'

module Ecommerce
  describe PurchaseController do
    context '#push' do
      describe 'user logged in to locomotive' do
        it 'sends each order' do
          request.env['HTTP_REFERER'] = 'a redirect'
          PurchaseController.any_instance.stub(:authenticate_user!).and_return(
            true)
          PurchaseController.any_instance.stub(
            :locomotive_account_signed_in?).and_return(true)
          mocks = [mock_model('Purchase'), mock_model('Purchase')]
          mocks.each do |mock|
            PurchaseController.should_receive(:send_purchase).with(mock)
          end
          Purchase.stub(:where).and_return(mocks)
          post :push, { use_route: :ecommerce }
          flash[:notice].should == 'Pushing orders.'
        end
      end

      describe 'user not logged in to locomotive' do
        it "doesn't send the orders" do
          request.env['HTTP_REFERER'] = 'a redirect'
          PurchaseController.any_instance.stub(:authenticate_user!).and_return(
            true)
          PurchaseController.any_instance.stub(
            :locomotive_account_signed_in?).and_return(false)
          post :push, { use_route: :ecommerce }
          flash[:notice].should_not == 'Pushing orders.'
        end
      end
    end
  end
end
