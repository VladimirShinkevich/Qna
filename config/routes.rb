Rails.application.routes.draw do
  root 'questions#index'
  devise_for :users
  

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy]
  end
end
