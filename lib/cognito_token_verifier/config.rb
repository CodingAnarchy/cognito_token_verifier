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

    def validate!
      raise ConfigSetupError.new(self) unless aws_region.present? and user_pool_id.present?
    end

    def allow_expired_tokens?
      allow_expired_tokens
    end

    # def jwks
    #   begin
    #     raise ConfigSetupError.new(self) unless aws_region.present? and user_pool_id.present?
    #     @jwks ||= JSON.parse(RestClient.get(jwk_url))
    #   rescue RestClient::Exception, JSON::JSONError => e
    #     raise JWKFetchError
    #   end
    # end

    # TODO Because the load balancer does not encrypt the user claims, we
    # recommend that you configure the target group to use HTTPS. If you
    # configure your target group to use HTTP, be sure to restrict the traffic
    # to your load balancer using security groups. We also recommend that you
    # verify the signature before doing any authorization based on the claims.
    # To get the public key, get the key ID from the JWT header and use it to
    # look up the public key from the endpoint. The endpoint for each AWS Region
    # is as follows:
    #  https://public-keys.auth.elb.region.amazonaws.com/key-id
    # See: https://docs.aws.amazon.com/elasticloadbalancing/latest/application/listener-authenticate-users.html
    # def iss
    #   "https://cognito-idp.#{aws_region}.amazonaws.com/#{user_pool_id}"
    # end

    private

    # def jwk_url
    #   "#{iss}/.well-known/jwks.json"
    # end
  end
end
