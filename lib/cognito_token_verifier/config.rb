require 'rest-client'

module CognitoTokenVerifier
  class Config
    attr_accessor :aws_region, :user_pool_id, :allow_expired_tokens

    def initialize
      @aws_region = nil
      @user_pool_id = nil
      @token_use = 'all'
      @allow_expired_tokens = false
    end

    def allow_expired_tokens?
      allow_expired_tokens
    end

    def jwks
      raise ConfigSetupError.new(self) unless aws_region.present? and user_pool_id.present?
      @jwks ||= JSON.parse(RestClient.get(jwk_url))
      # TODO: rescue RestClient and JSON errors here to present a more user-friendly error
    end

    def iss
      "https://cognito-idp.#{aws_region}.amazonaws.com/#{user_pool_id}"
    end

    private

    def jwk_url
      "#{iss}/.well-known/jwks.json"
    end
  end
end
