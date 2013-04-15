Rails.application.routes.draw do
  root :to => "home#index"
  match "cart"         => "test#show_cart",       :as => "cart",         via: :get
  match "checkout_new" => "test#new_checkout",    :as => "new_checkout", via: :get
  match "checkout"     => "test#show_checkout",   :as => "checkout",     via: :get
  match "purchases"    => "test#index_purchases", :as => "purchases",    via: :get
  match "products"     => "test#index_products",  :as => "products",     via: :get
  match "product/:id/" => "test#show_product",    :as => "product",      via: :get

  mount Ecommerce::Engine => "/"
end
