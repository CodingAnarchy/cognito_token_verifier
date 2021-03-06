require 'rest-client'

module CognitoTokenVerifier
  class Config
    attr_accessor :aws_region, :user_pool_id, :token_use, :allow_expired_tokens

    def initialize
      @aws_region = nil
      @user_pool_id = nil
      @token_use = 'all'
      @allow_expired_tokens = false
    end

    def any_token_use?
      ['all', 'any', ['id', 'access']].any?{|usage| usage == token_use }
    end

    def allow_expired_tokens?
      allow_expired_tokens
    end

    def jwks
      begin
        raise ConfigSetupError.new(self) unless aws_region.present? and user_pool_id.present?
        @jwks ||= JSON.parse(RestClient.get(jwk_url))
      rescue RestClient::Exception, JSON::JSONError => e
        raise JWKFetchError
      end
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
