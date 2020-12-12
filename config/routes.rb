Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, { format: 'json' } do
    resources :users, only: %i(index)
  end

  devise_for :users
end
