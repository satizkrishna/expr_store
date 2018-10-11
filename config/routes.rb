Rails.application.routes.draw do
  
  root to: "home#index"
  
  match '/category/:slug' => 'home#category' , via: [:get]

  match '/item/:slug' => 'home#item' , via: [:get]
  
  match '/cart/add/:sku' => 'cart#add_to_cart' , via: [:post]

  match '/cart/remove/:sku' => 'cart#remove_from_cart' , via: [:post]

  match '/cart/remove_coupon/:coupon' => 'cart#remove_coupon' , via: [:post]

  match '/cart/apply_coupon/:coupon' => 'cart#apply_coupon' , via: [:post]

  match '/cart/complete' => 'cart#complete_purchase' , via: [:get]  

  match '/cart' => 'cart#cart' , via: [:get]

  match '/reports/main' => 'reports#master_report' , via: [:get]

  devise_for :users

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
