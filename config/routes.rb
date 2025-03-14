Rails.application.routes.draw do
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :accounts, only: [:create, :show, :index] do
    resources :transactions, only: [:create, :show, :index]
    resources :transfers, only: [:create]
  end
end
