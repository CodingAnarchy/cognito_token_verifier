require 'cognito_token_verifier/controllers/cognito_verifiable'

describe CognitoTokenVerifier::Controllers::CognitoVerifiable, type: :controller do
  controller(TestController) do
    include CognitoTokenVerifier::Controllers::CognitoVerifiable

    def index; end
  end

  before :each do
    api_request_authorize
  end

  describe "before_action verify_cognito_token" do
    it "calls the before_action filter to verify the token" do
      expect(controller).to receive(:verify_cognito_token).and_call_original
      get :index
    end
  end
end
