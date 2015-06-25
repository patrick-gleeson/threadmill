Rails.application.routes.draw do
  
  resources :stocks
  resources :orders
  resources :items
  devise_for :users
  root to: "home#index"
end
