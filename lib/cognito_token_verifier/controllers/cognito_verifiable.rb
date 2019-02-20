require 'active_support/concern'
require 'json/jwt'

module CognitoTokenVerifier
  module Controllers
    module CognitoVerifiable
      extend ActiveSupport::Concern

      included do
        before_action :verify_cognito_token
      end

      def cognito_token
        return @cognito_token if @cognito_token.present? # Caching here, so gem user can access token themselves for additional checks
        token = request.headers['authorization']
        raise TokenMissing unless token.present?
        header, _ = token.split('.')
        header = JSON.parse(Base64.decode64(header))
        jwk = JSON::JWK.new(CognitoTokenVerifier.config.jwks["keys"].detect{|jwk| jwk['kid'] == header['kid']})
        @cognito_token = JSON::JWT.decode(token, jwk)
        # TODO: rescue errors for JSON/JWK/JWT parsing/decoding to present user-friendly "token could not be decoded" error
      end

      def verify_cognito_token
        raise TokenExpired if cognito_token['exp'] < Time.now.to_i and not CognitoTokenVerifier.config.allow_expired?
      end
    end
  end
end
