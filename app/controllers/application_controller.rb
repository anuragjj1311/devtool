class ApplicationController < ActionController::API
  include ExceptionHandler
  
  protected
  
  def render_error(message, status = :unprocessable_entity)
    render json: { error: message }, status: status
  end
  
  def render_success(data = {}, message = 'Success')
    render json: { message: message, data: data }, status: :ok
  end
end