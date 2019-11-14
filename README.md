# CognitoTokenVerifier [![Build Status](https://travis-ci.org/CodingAnarchy/cognito_token_verifier.svg?branch=master)](https://travis-ci.org/CodingAnarchy/cognito_token_verifier)

Verify and decode AWS Cognito tokens for use in your Rails 5.2+ application. Rails 4.2 may work on 0.3+, but as it is no longer supported for security fixes by the Rails team, I make no guarantees of this and changes may result that break compatibility.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'cognito_token_verifier'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install cognito_token_verifier

## Usage

This gem provides a `Token` class that will verify and decode a token, as well as controller macros to run verification on tokens automatically.  To use, first configure the gem with the appropriate AWS configuration, as below:

```ruby
CognitoTokenVerifier.configure do |config|
  config.aws_region = 'us-west-2'
  config.user_pool_id = 'your_user_pool_id'
  config.token_use = 'id' # acceptable options are 'id' and 'access'; can be an array for both options - defaults to allowing either cognito token type
end
```

You can then include the controller macros in your controller and override the methods to handle expired and invalid tokens (or you can skip this step and allow errors to be raised).

```ruby
class ExampleController < ActionController::Base
  include CognitoTokenVerifier::ControllerMacros

  ...

  private

  def handle_expired_token(exception)
    # Do what you want here
  end

  def handle_invalid_token(exception)
    # Do what you want here
  end
end
```

You can also access the Cognito token in the controller yourself for additional verification (such as custom attributes). For example:

```ruby
   def handle_custom_attribute
     cognito_token.decoded_token['custom:attr'] == <some_value>
  end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/CodingAnarchy/cognito_token_verifier.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
