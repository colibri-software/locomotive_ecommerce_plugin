module HbirdEcommerce
  class HbirdEcommerceDrop < ::Liquid::Drop
    def initialize(source)
      @source = source
      urls = ['cart_url', 'checkout_url', 'new_checkout_url', 'product_url',
        'products_url', 'purchases_url']
      urls.each do |name|
        self.class.send(:define_method, name) do
          source.mounted_rack_app.config_or_default(name)
        end
      end
    end

    protected
    attr_reader :source
  end
end
