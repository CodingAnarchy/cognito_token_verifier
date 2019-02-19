require "bundler/setup"
require 'fixtures/application'
require 'fixtures/controllers'
require 'rspec/rails'
require "cognito_token_verifier"

#ActiveRecord::Base.establish_connection adapter: "sqlite3", database: ":memory:"
#load File.dirname(__FILE__) + '/schema.rb'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!
  config.expose_dsl_globally = true

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
