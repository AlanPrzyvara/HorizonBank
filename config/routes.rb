Rails.application.routes.draw do
  resources :accounts, only: [:create] do
    resources :transactions, only: [:create, :show, :index]
  end
end
