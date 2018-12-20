Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  # resources :users, only: [:index, :show]
  get "/users", to: "users#index"
  get "/user/:id", to: "users#show"
  resources :clock_sessions
  resources :users, only: [:show] do
    resources :clock_sessions do
      get "total", on: :collection
    end
  end
  root to: "clock_sessions#index"
end
