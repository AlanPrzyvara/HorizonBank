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

  private

  def account_params
    params.require(:account).permit(:name, :birthdate, :document)
  end
end
