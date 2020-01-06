class ApplicationController < ActionController::API
  require 'json_web_token'

  before_action :authenticate_request!

  def authenticate_request!
    if !payload || !JsonWebToken.validate_payload(payload.first)
      return invalid_authentication
    end

    load_current_user!
    invalid_authentication unless @current_user
  end

  def invalid_authentication
    render json: { error: 'Invalid request' }, status: :unauthorized
  end

  def payload
    auth_header = request.headers['Authorization']
    token = auth_header.split(' ').last
    JsonWebToken.decode(token)
  rescue StandardError
    nil
  end

  def load_current_user!
    @current_user = User.find_by(id: payload[0]['user_id'])
  end
end
