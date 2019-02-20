require "bundler/setup"
require 'fixtures/application'
require 'fixtures/controllers'
require 'fixtures/constants'
require 'rspec/rails'
require "cognito_token_verifier"
require "support/auth_helper"
require "byebug"

CognitoTokenVerifier.configure do |config|
  config.aws_region = 'us-west-2'
  config.user_pool_id = 'us-west-2_94KXV27rr'
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.expose_dsl_globally = true

  config.include AuthHelper, type: :controller

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
