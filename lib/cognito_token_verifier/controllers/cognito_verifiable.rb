require 'active_support/concern'
require "cognito_token_verifier/token"

module CognitoTokenVerifier
  module Controllers
    module CognitoVerifiable
      extend ActiveSupport::Concern

      included do
        before_action :verify_cognito_token
      end

      def cognito_token
        return @cognito_token if @cognito_token.present? # Caching here, so gem user can access token themselves for additional checks
        raise TokenMissing unless request.headers['authorization'].present?
        @cognito_token = CognitoTokenVerifier::Token.new(request.headers['authorization'])
      end

      def verify_cognito_token
        raise TokenExpired if cognito_token.expired?
      end
    end
  end
end
