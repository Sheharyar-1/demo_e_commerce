Rails.application.routes.draw do
  get 'products/index'
  root 'products#index'
  get 'user/list', to: 'user#list', as: 'list_user'
  patch 'carts/placed', to: 'carts#placed', as: 'placed_order'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :user, except: [:show]
  resources :order_items
  resource :carts, only: [:show]

  resources :products do 
    resources :multi_step
  end

end
