Rails.application.routes.draw do
  root 'application#index'
  resources :frames, only: [:create, :show] do
    resources :circles, only: [:create]
  end

  resources :circles, only: [:update, :index]
end