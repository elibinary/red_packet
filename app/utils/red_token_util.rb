require 'jwt'

class RedTokenUtil
  class << self
    def encode(payload)
      payload[:exp] ||= 1.months.after.to_i
      JWT.encode payload, Setting.jwt_secret
    end

    def decode(token)
      if token.present?
        ret = JWT.decode token, Setting.jwt_secret
        ret[0]
      end
    rescue JWT::VerificationError
      # 签名错误
      nil
    rescue JWT::ExpiredSignature
      # 参数错误
      nil
    rescue JWT::DecodeError
      nil
    end
  end
end