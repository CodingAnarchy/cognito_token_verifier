require 'active_support/concern'

module CognitoTokenVerifier
  module Controllers
    module CognitoVerifiable
      extend ActiveSupport::Concern

      included do
        before_action :verify_cognito_token
      end

      def parse_cognito_token
        token = request.headers['authorization']
        header, _ = token.split('.')
        header = JSON.parse(Base64.decode64(header))
      end

      def verify_cognito_token
        payload = parse_cognito_token
      end
    end
  end
end
