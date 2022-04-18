require 'active_support/concern'
require "cognito_token_verifier/token"

module CognitoTokenVerifier
  module ControllerMacros
    extend ActiveSupport::Concern

    included do
      before_action :verify_cognito_token
      rescue_from CognitoTokenVerifier::TokenExpired, with: :handle_expired_token
      rescue_from CognitoTokenVerifier::Error, with: :handle_invalid_token
    end

    def cognito_token
      return @cognito_token if @cognito_token.present? # Caching here, so gem user can access token themselves for additional checks
      @cognito_token = CognitoTokenVerifier::Token.new(find_jwt_claims!)
    end

    # Support cognito authentication off loaded by ALB
    # https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-authenticate-users.html
    def find_jwt_claims!
      request.headers['x-amzn-oidc-data'].presence || request.headers['authorization'].presence || raise(TokenMissing)
    end

    def verify_cognito_token
      raise TokenExpired if cognito_token.expired?
      raise IncorrectTokenType.new(cognito_token) unless cognito_token.valid_token_use?
      raise InvalidIss.new(cognito_token) unless cognito_token.valid_iss?
    end

    def handle_expired_token(exception)
      raise exception # Just re-raise the exception: this is for the user to overwrite
    end

    def handle_invalid_token(exception)
      raise exception # Just re-raise the exception: this is for the user to overwrite
    end
  end
end
