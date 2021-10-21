Rails.application.routes.draw do
  root 'questions#index'
  devise_for :users
  

  resources :questions do
    resources :answers, shallow: true, only: [:create, :update, :destroy] do
      member do
        patch :mark_as_best
      end
    end
  end
end
