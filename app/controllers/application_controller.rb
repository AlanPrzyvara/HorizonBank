class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  before_action :authenticate_account
  protected

  def record_not_found(error)
    render json: { errors: ['Não foi possível encontrar nenhum registro'] }, status: :not_found
  end
  rescue => e
    render json: { errors: e.message }, status: :internal_server_error

    private

    def authenticate_account
      token = request.headers['Authorization']&.split(' ')&.last
      return render json: { error: "Token não fornecido" }, status: :unauthorized unless token

      begin
        decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
        @current_account = Account.find(decoded_token['account_id'])
      rescue JWT::DecodeError
        render json: { error: "Token inválido" }, status: :unauthorized
      end
    end

    def current_account
      @current_account
    end
end
