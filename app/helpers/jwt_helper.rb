require 'jwt'
module JwtHelper
    def decode_token(token)
      begin
        JWT.decode(token, Rails.application.secret_key_base, true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  
    def current_user
      if token = request.headers['Authorization']
        user_id = decode_token(token)[0]['user_id']
        User.find_by(id: user_id)
      end
    end
  end
  