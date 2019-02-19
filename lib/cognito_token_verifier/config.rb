module CognitoTokenVerifier
  class Config
    attr_accessor :aws_region, :user_pool_id

    def initialize
      @aws_region = nil
      @user_pool_id = nil
    end
  end
end
