Rails.application.routes.draw do
  root 'application#index'
  resources :frames do
    resources :circles
  end

  resources :circles
end