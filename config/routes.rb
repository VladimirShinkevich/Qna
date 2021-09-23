Rails.application.routes.draw do
  devise_for :users
  root to: 'questions#new'

  resources :questions do
    resources :answers
  end
end
