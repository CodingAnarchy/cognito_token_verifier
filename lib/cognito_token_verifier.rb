require "cognito_token_verifier/version"
require "cognito_token_verifier/errors"
require "cognito_token_verifier/config"
require "cognito_token_verifier/token"
require "cognito_token_verifier/controller_macros"

module CognitoTokenVerifier
  class << self
    attr_accessor :config
  end

  def self.config
    @config ||= Config.new
  end

  def self.reset
    @config = Config.new
  end

  def self.configure
    yield(config)
  end
end
