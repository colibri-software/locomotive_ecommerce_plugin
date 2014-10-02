Locomotive::Ecommerce::Engine.routes.draw do
  resources :cart, :only => [:update]
  resources :checkout,  :controller => "purchase",
    :only => [:create, :update]

  match "add_to_cart/:product_id"      => "order#create",
    :via => :post,   :as => "add_to_cart"
  match "remove_from_cart/:product_id" => "order#destroy",
    :via => :delete, :as => "remove_from_cart"
  match "push_orders"                  => "purchase#push",
    :via => :get,    :as => "push_orders"

  mount StripeHelper::Engine => "/"
end
