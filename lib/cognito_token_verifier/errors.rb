module CognitoTokenVerifier
  class Error < StandardError; end

  class ConfigSetupError < StandardError
    def initialize(config)
      @aws_region = config.aws_region
      @user_pool_id = config.user_pool_id
    end

    def message
      "Configuration of CognitoTokenVerifier is incomplete: please verify aws_region (#{@aws_region}) and Cognito user_pool_id (#{@user_pool_id})."
    end
  end

  class TokenMissing < CognitoTokenVerifier::Error
    def message
      "Cognito token not provided.  Please retransmit request with Cognito token in authorization header."
    end
  end
  
  class TokenExpired < CognitoTokenVerifier::Error
    def message
      "Cognito token has expired.  Please reauthorize and try again."
    end
  end

  class IncorrectTokenType < CognitoTokenVerifier::Error
    def initialize(token)
      @token_use = token.decoded_token['token_use']
    end
    
    def message
      "Incorrect token type. Received #{@token_use} while expecting one of #{[CognitoTokenVerifier.config.token_use].flatten}."
    end
  end

  class InvalidIss < CognitoTokenVerifier::Error
    def initialize(token)
      @iss = token.decoded_token['iss']
    end

    def message
      "Invalid token ISS reference. Received #{@iss} while expecting #{CognitoTokenVerifier.config.iss}."
    end
  end
end
