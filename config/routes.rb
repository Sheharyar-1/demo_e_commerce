Rails.application.routes.draw do
  root 'user#index'
  get 'user/list', to: 'user#list', as: 'list_user'

  devise_for :users, controllers: { registrations: 'users/registrations' }

  resources :user, except: [:show]
end
