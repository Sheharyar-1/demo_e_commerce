Rails.application.routes.draw do
  get 'products/index'
  root 'user#index'
  get 'user/list', to: 'user#list', as: 'list_user'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :user, except: [:show]
  resources :order_items
  resource :carts, only: [:show]

  resources :products do 
    resources :multi_step
  end

end
