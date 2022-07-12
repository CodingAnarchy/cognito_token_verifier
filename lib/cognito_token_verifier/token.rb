require 'json/jwt'

module CognitoTokenVerifier
  class Token
    attr_reader :encoded_jwt, :header, :idp_type

    def initialize(jwt)
      @encoded_jwt = jwt
      @header = JSON.parse(Base64.decode64(jwt.split('.')[0]))
      @idp_type = header["signer"]&.include?("arn:aws:elasticloadbalancing") ? :alb : :cognito
    rescue JSON::JSONError
      raise TokenDecodingError
    end

    def decoded_token
      @decoded_token ||= begin
        @jwk = JSON::JWK.new(jwks["keys"].detect{|jwk| jwk['kid'] == header['kid']})
        JSON::JWT.decode(encoded_jwt, @jwk)
      rescue JSON::JWS::VerificationFailed
        raise TokenDecodingError
      end
    end

    def expired?
      decoded_token['exp'] < Time.now.to_i and not CognitoTokenVerifier.config.allow_expired_tokens?
    end

    def jwks
      CognitoTokenVerifier.config.validate!
      @jwks ||= JSON.parse(RestClient.get(jwk_url))
    rescue RestClient::Exception, JSON::JSONError => e
      raise JWKFetchError
    end

    def jwk_url
      case idp_type
      when :alb
        "#{iss}/#{header['kid']}"
      else
        "#{iss}/.well-known/jwks.json"
      end
    end

    def iss
      case idp_type
      when :alb
        "https://public-keys.auth.elb.#{CognitoTokenVerifier.config.aws_region}.amazonaws.com"
      else
        "https://cognito-idp.#{CognitoTokenVerifier.config.aws_region}.amazonaws.com/#{CognitoTokenVerifier.config.user_pool_id}"
      end
    end

    def valid_token_use?
      CognitoTokenVerifier.config.any_token_use? || [CognitoTokenVerifier.config.token_use].flatten.include?(decoded_token['token_use'])
    end

    def alb_claim?
      idp_type == :alb
    end

    def valid_iss?
      decoded_token['iss'] == iss
    end
  end
end
