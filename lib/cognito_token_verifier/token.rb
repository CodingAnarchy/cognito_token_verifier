require 'json/jwt'

module CognitoTokenVerifier
  class Token
    attr_reader :header, :decoded_token

    def initialize(jwt)
      @header= JSON.parse(Base64.decode64(jwt.split('.')[0]))
      @jwk = JSON::JWK.new(CognitoTokenVerifier.config.jwks["keys"].detect{|jwk| jwk['kid'] == header['kid']})
      @decoded_token = JSON::JWT.decode(jwt, @jwk)
      # TODO: rescue errors for JSON/JWK/JWT parsing/decoding to present user-friendly "token could not be decoded" error
    end

    def expired?
      decoded_token['exp'] < Time.now.to_i and not CognitoTokenVerifier.config.allow_expired_tokens?
    end

    def valid_token_use?
      CognitoTokenVerifier.config.any_token_use? || [CognitoTokenVerifier.config.token_use].flatten.include?(decoded_token['token_use'])
    end

    def valid_iss?
      decoded_token['iss'] == CognitoTokenVerifier.config.iss
    end
  end
end