Rails.application.routes.draw do
  resources :accounts, only: [:create] do
    #resources :transactions, only: [:create, :show, :index] usar index para listar todas as transações ao em vez de :show
    resources :transactions, only: [:create,:show, :index]
    resources :transfers, only: [:create]
  end
end
