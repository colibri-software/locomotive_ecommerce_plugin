Ecommerce::Engine.routes.draw do
  root :to => "home#index"

  resources :cart, :only => [:show, :update]

  match "add_to_cart/:product_id" => "order#create",
    :via => :post,   :as => "add_to_cart"
  match "remove_from_cart/:product_id" => "order#destroy",
    :via => :delete, :as => "remove_from_cart"

  resources :checkout,  :controller => "purchase", :except => [:edit, :index]
  resources :purchases, :controller => "purchase", :only => [:index]

  match "order_complete" => "purchase#update",
    :via => :get, :as => "order_complete"

  resources :products, :only => [:index, :show]
end
