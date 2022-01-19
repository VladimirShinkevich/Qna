# frozen_string_literal: true

Rails.application.routes.draw do
  root 'questions#index'

  devise_for :users, controllers: { omniauth_callbacks: 'oauth_callbacks' }

  namespace :users do
    resources :get_emails, only: %i[show create]
  end

  resources :files, only: [:destroy]
  resources :links, only: [:destroy]
  resources :awards, only: [:index]
  resources :votes, only: %i[create destroy]

  mount ActionCable.server => '/cable'

  resources :questions do
    resources :comments, only: :create
    resources :answers, shallow: true, only: %i[create update destroy] do
      member do
        patch :mark_as_best
      end
      resources :comments, only: :create
    end
  end
end
