class Api::BaseController < ApplicationController
  before_action :authenticate_token

  if Rails.env.production?
    rescue_from(Exception, with: :respond_all_error)
  end

  private

  def authenticate_token
    unless current_user
      render_error_for_code(INVALID_TOKEN)
    end
  end

  def current_user
    @current_user ||= fetch_user
  end

  def fetch_user
    token = params[:red_token] || request.headers['RED-TOKEN']
    return unless token
    payload = RedTokenUtil.decode(token)
    return unless payload
    User.find_by(user_key: payload['openid'])
  end

  helper_method :current_user
end