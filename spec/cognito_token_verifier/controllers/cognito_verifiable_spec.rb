require 'cognito_token_verifier/controllers/cognito_verifiable'

describe CognitoTokenVerifier::Controllers::CognitoVerifiable, type: :controller do
  controller(TestController) do
    include CognitoTokenVerifier::Controllers::CognitoVerifiable

    def index; end
  end

  context "without auth token" do
    it "raises a TokenMissing error" do
      expect{ get :index }.to raise_error(CognitoTokenVerifier::TokenMissing)
    end
  end

  context "with auth token" do
    before :each do
      api_request_authorize
    end

    it "raises a TokenExpired error" do
      expect { get :index }.to raise_error(CognitoTokenVerifier::TokenExpired)
    end

    context "with expired token check bypassed" do
      before :each do |example|
        CognitoTokenVerifier.config.allow_expired_tokens = true
      end

      describe "before_action verify_cognito_token" do
        it "calls the before_action filter to verify the token" do
          expect(controller).to receive(:verify_cognito_token).and_call_original
          get :index
        end
      end

      it "raises an IncorrectTokenType error if the token type doesn't match" do
        CognitoTokenVerifier.config.token_use = 'access'
        expect { get :index }.to raise_error(CognitoTokenVerifier::IncorrectTokenType)
      end

      it "raises an InvalidIss error if the ISS referent doesn't match" do
        allow_any_instance_of(CognitoTokenVerifier::Token).to receive(:valid_iss?).and_return(false)
        expect { get :index }.to raise_error(CognitoTokenVerifier::InvalidIss)
      end
    end
  end
end
