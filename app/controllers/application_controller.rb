class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found(error)
    render json: { errors: ['Não foi possível encontrar nenhum registro'] }, status: :not_found
  end
  rescue => e
    render json: { errors: e.message }, status: :internal_server_error
end
