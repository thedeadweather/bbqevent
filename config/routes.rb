Rails.application.routes.draw do
  devise_for :users, controllers: {
    omniauth_callbacks: 'users/omniauth_callbacks'
  }

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  root "events#index"

  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
    resources :photos, only: [:create, :destroy]
    post :show, on: :member
  end

  resources :users, only: [:show, :edit, :update]
end
