require 'jwt'
module JwtHelper
  def store_token(user, token, expiration)
    user.update(token: token, token_expires_at: expiration)
  end

  def encode_token(user, expiration = 3.days.from_now)
    expiration = 3.days.from_now.to_i
    payload = {
      user_id: user.id,
      created_at: user.created_at.to_i,
      exp: expiration.to_i
    }
    secret_key = Rails.application.credentials.secret_key_base
    JWT.encode(payload, secret_key, 'HS256')
  end

  def decode_token(token)
    begin
      decoded_token = JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      if token_not_expired?(decoded_token)
        return decoded_token
      else
        nil
      end
    rescue JWT::DecodeError
      nil
    end
  end

  def token_not_expired?(decoded_token)
    expiration = decoded_token['exp'].to_i
    current_time = Time.now.to_i

    expiration > current_time
  end
  
  def current_user
    if token = request.headers['Authorization']
      decoded_token = decode_token(token)

      if decoded_token
        user_id = decoded_token['user_id']
        user = User.find_by(id: user_id)

        if user.present? && user.token == token && user.token_expires_at > Time.now
          return user
        end
      end
    end

    nil
  end
end
