require 'jwt'

module AuthHelper
  def api_request_authorize
    request.accept = 'application/json'
    request.headers.merge!(authorization: COGNITO_TEST_TOKEN)
  end
end
