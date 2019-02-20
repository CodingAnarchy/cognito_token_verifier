module CognitoTokenVerifier
  class ConfigSetupError < StandardError
    def initialize(config)
      @aws_region = config.aws_region
      @user_pool_id = config.user_pool_id
    end

    def message
      "Configuration of CognitoTokenVerifier is incomplete: please verify aws_region (#{@aws_region}) and Cognito user_pool_id (#{@user_pool_id})."
    end
  end

  class TokenMissing < StandardError
    def message
      "Cognito token not provided.  Please retransmit request with Cognito token in authorization header."
    end
  end
  
  class TokenExpired < StandardError
    def message
      "Cognito token has expired.  Please reauthorize and try again."
    end
  end
end
