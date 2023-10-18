require 'byebug'
require 'jwt'
class UsersController < ApplicationController
    skip_before_action :authenticate_request, only: [:register, :login]
    def register 
        email = params["email"]
        password = params["password"]
        user = User.new(user_params)
        if user.save
          render json: { message: 'User registered successfully' }
        else
          render json: { error: user.errors.full_messages.join(', ') }, status: :bad_request
        end
      end
    
      def login
        user = User.find_by(email: params[:email])
        if user && user.authenticate(params[:password])
          token = encode_token({ user_id: user.id })
          render json: { token: token }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end
    
      private
    
      def user_params
        params.permit(:email, :password)
      end
    
      def encode_token(payload)
        JWT.encode(payload, Rails.application.secret_key_base)
      end
end
