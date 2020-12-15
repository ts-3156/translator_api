Rails.application.routes.draw do
  root to: 'home#index'

  namespace :api, { format: 'json' } do
    resource :user, only: %i(show)
    resources :webhooks, only: %i(create)
    resources :checkout_sessions, only: %i(create)
  end

  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks' }
  devise_scope :user do
    delete 'users/sign_out', to: 'devise/sessions#destroy', as: :destroy_user_session
  end
end
