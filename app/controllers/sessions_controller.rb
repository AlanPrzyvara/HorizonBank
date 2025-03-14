class SessionsController < ApplicationController
  require 'jwt'

  # Login
  def create
    account = Account.find_by(document: params[:document])

    if account&.authenticate(params[:password])
      token = generate_jwt(account)
      render json: { token: token, account: AccountSerializer.new(account).serializable_hash }, status: :ok
    else
      render json: { error: "Documento ou senha inválidos" }, status: :unauthorized
    end
  end

  # Logout (Opcional, útil se for armazenar tokens no banco)
  def destroy
    current_account.update(jwt_token: nil) if current_account
    render json: { message: "Logout realizado com sucesso" }, status: :ok
  end

  private

  def generate_jwt(account)
    payload = { account_id: account.id, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.secrets.secret_key_base)
  end
end
