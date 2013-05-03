require 'spec_helper'
require 'ecommerce/ecommerce_drop'
require 'uri'

module Ecommerce
  describe EcommerceDrop do
    context 'respond to' do
      let!(:drop) { EcommerceDrop.new(mock(Ecommerce)) }

      it 'cart_url' do
        drop.should respond_to :cart_url
      end

      it 'checkout_url' do
        drop.should respond_to :checkout_url
      end

      it 'new_checkout_url' do
        drop.should respond_to :new_checkout_url
      end

      it 'product_url' do
        drop.should respond_to :product_url
      end

      it 'products_url' do
        drop.should respond_to :products_url
      end

      it 'purchases_url' do
        drop.should respond_to :purchases_url
      end
    end

    context 'not respond to' do
      let!(:drop) { EcommerceDrop.new(mock(Ecommerce)) }

      it 'other_url' do
        drop.should_not respond_to :other_url
      end
    end

    it 'returns a uri' do
      engine, plugin = mock(Engine), mock(Ecommerce)
      plugin.stub(:mounted_rack_app).and_return(engine)
      engine.stub(:config_or_default).and_return('/cart')
      drop = EcommerceDrop.new(plugin)
      expect { URI(drop.cart_url) }.not_to raise_error URI::InvalidURIError
    end
  end
end
