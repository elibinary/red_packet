# encoding: utf-8
module ErrorHandlable
  extend ActiveSupport::Concern

  INVALID_TOKEN = 1001

  ERROR_MESSAGES = {
    INVALID_TOKEN => "无效的 Token"
  }.freeze

  private

  def render_fail(message)
    render json: { success: 0, message: message }, status: 200
  end

  def render_error(code, message, status = 400)
    render json: { error: { code: code, message: message } }, status: status
  end

  def render_error_for_code(code, status = 400)
    render_error(code, message_of_code(code), status)
  end

  def message_of_code(code)
    ERROR_MESSAGES[code] || '未知错误'
  end

  def respond_all_error(exception)
    code = case exception
             when ActiveRecord::UnknownAttributeError, ArgumentError
               500
             when ActiveRecord::RecordNotFound
               404
             when ActiveRecord::RecordInvalid
               422
             else
               500
           end
    respond_with_error(exception, code)
  end

  def respond_with_error(exception, code)
    # write log

    render_error("1#{code}", '服务器错误', code)
  end
end