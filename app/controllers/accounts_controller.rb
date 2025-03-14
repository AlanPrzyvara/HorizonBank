class AccountsController < ApplicationController
  skip_before_action :authenticate_account, only: [:create]  # Permite criar conta sem estar logado

  def create
    account = Account.new(account_params)
    if account.save
      render json: AccountSerializer.new(account).serializable_hash.merge({ password: account.password }), status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    render json: { account: AccountSerializer.new(current_account).serializable_hash }, status: :ok
  end

  def index
    accounts = Account.all.order(created_at: :asc)
    render json: { accounts: AccountSerializer.new(accounts).serializable_hash }, status: :ok
  end

  private

  def account_params
    params.require(:account).permit(:name, :birthdate, :document, :password, :balance)
  end
end
