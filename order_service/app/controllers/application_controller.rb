class ApplicationController < ActionController::API
  rescue_from StandardError, with: :handle_internal_error

  rescue_from Orders::Error do |e|
    render json: { error: e.message }, status: :unprocessable_entity
  end

  def handle_internal_error(exception)
    render json: { error: "Internal Server Error", exception: exception.message }, status: :unprocessable_entity
  end
end
