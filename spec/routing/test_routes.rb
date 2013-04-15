require 'spec_helper'

describe 'routing' do
  it "routes /checkout/new to test#new_checkout" do
    expect(get: '/checkout/new').to route_to(
      controller: 'test', action: 'new_checkout')
  end

  it "routes /product/1 to test#product" do
    expect(get: '/product/1/').to route_to(
      controller: 'test', action: 'show_product', id: '1')
  end
end
