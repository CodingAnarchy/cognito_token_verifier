require "cognito_token_verifier/version"

module CognitoTokenVerifier
  class Error < StandardError; end

  class << self
    attr_accessor :config

    def config
      @config ||= Config.new
    end

    def reset
      @config = Config.new
    end

    def configure
      yield(config)
    end
  end
end
