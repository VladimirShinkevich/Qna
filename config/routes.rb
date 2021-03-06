# frozen_string_literal: true

require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, ->(u) { u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  root 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  namespace :users do
    resources :get_emails, only: %i[show create]
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :awards, only: [:index]
  resources :votes, only: %i[create destroy]
  resources :searches, only: :new
  get 'search/result', to: 'searches#result'

  mount ActionCable.server => '/cable'

  resources :questions do
    resource :subscription, only: %i[create destroy]
    resources :comments, only: :create
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_as_best
      end
      resources :comments, only: :create
    end
  end

  namespace :api do
    namespace :v1 do
      resources :profiles, only: [:index] do
        get :me, on: :collection
      end

      resources :questions do
        resources :answers
      end
    end
  end
end
