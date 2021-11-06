Rails.application.routes.draw do
  root 'questions#index'
  devise_for :users
  
  resources :files, only: [:destroy]
  resources :links, only: [:destroy]

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member do
        patch :mark_as_best
      end
    end
  end
end
