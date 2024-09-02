Rails.application.routes.draw do
  resources :accounts, only: [:create, :show] do
    resources :transactions, only: [:create,:show, :index]
    resources :transfers, only: [:create]
  end
end
