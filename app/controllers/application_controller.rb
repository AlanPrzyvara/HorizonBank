class ApplicationController < ActionController::Base
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  protected

  def record_not_found(error)
    render json: { errors: [error.message] }, status: :not_found
  end
end
