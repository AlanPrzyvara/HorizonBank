class AccountsController < ApplicationController
  # Post /accounts
  def create
    account = Account.new(account_params)
    if account.save
      render json: AccountSerializer.new(account).serializable_hash.merge({ password: account.password }), status: :created
    else
      render json: { errors: account.errors.full_messages }, status: :unprocessable_entity
    end
  end
  # Get /accounts/:id usado para mostrar um unico registro de conta
  def show
    account = Account.find(params[:id])
    render json: { account: AccountSerializer.new(account).serializable_hash }, status: :ok
  end

  def index
    accounts = Account.all.order(created_at: :asc)
    render json: { accounts: AccountSerializer.new(accounts).serializable_hash }, status: :ok
  end

  private

  def account_params
    params.require(:account).permit(:name, :birthdate, :document, :balance)
  end
end
