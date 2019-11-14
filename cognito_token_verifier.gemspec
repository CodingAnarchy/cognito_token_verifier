
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "cognito_token_verifier/version"

Gem::Specification.new do |spec|
  spec.name          = "cognito_token_verifier"
  spec.version       = CognitoTokenVerifier::VERSION
  spec.authors       = ["Matt Tanous"]
  spec.email         = ["mtanous22@gmail.com"]

  spec.summary       = %q{Verify and parse AWS Cognito JWTs to authenticate endpoints}
  spec.homepage      = "https://github.com/CodingAnarchy/cognito_token_verifier"
  spec.license       = "MIT"
  spec.required_ruby_version = ">= 2.3.8"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["homepage_uri"] = spec.homepage
    spec.metadata["source_code_uri"] = spec.homepage
    spec.metadata["changelog_uri"] = "https://github.com/CodingAnarchy/cognito_token_verifier/blob/master/CHANGELOG.md"
  end

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "activesupport", [">= 4.2", "< 6.1"]
  spec.add_runtime_dependency "json-jwt", "~> 1.11"
  spec.add_runtime_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "byebug", "~> 11.0"
  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", [">= 10.0", "< 14.0"]
  spec.add_development_dependency "rspec-rails", "~> 3.0"
  spec.add_development_dependency "actionpack", [">= 4.2", "< 6.1"]
end
