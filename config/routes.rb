Rails.application.routes.draw do
  get 'orders/index'
  get 'products/index'
  root 'products#index'
  get 'user/list', to: 'user#list', as: 'list_user'
  patch 'carts/placed', to: 'carts#placed', as: 'placed_order'
  get 'carts/address', to: 'carts#address', as: 'order_address'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :user, except: [:show]
  resources :order_items
  resource :carts, only: [:show]
  resources :orders, only: [:index]
  resources :products do 
    resources :multi_step
  end

end
