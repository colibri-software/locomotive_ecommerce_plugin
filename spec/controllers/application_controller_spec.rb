require 'spec_helper'

module HbirdEcommerce
  describe ApplicationController do
    context '#authenticate_user!' do
      context 'valid user' do
        controller(::HbirdEcommerce::ApplicationController) do
          before_filter :authenticate_user!

          def index 
            render :text => 'Test!'
          end
        end

        it 'does nothing' do
          controller.stub(:current_user).and_return(true)
          get :index
          response.body.should include('Test')
        end
      end

      context 'invalid user' do
        controller(::HbirdEcommerce::ApplicationController) do
          before_filter :authenticate_user!

          def index
            render :text => 'Test!'
          end
        end

        it 'prevents viewing the page' do
          controller.stub(:current_user).and_return(nil)
          controller.should_receive(:redirect_to)
          get :index
        end
      end
    end
  end
end
