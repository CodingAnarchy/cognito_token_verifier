require 'cognito_token_verifier/token'

describe CognitoTokenVerifier::Token do
  subject { CognitoTokenVerifier::Token.new(COGNITO_TEST_TOKEN) }

  it "provides access to the decoded token header" do
    expect(subject.header).to_not be_nil
  end

  it "provides access to the raw decoded token" do
    expect(subject.decoded_token).to_not be_nil
  end

  it "sets the correct idp type" do
    expect(subject.idp_type).to be :cognito
  end

  describe "#expired?" do
    it "returns true when the token is expired" do
      expect(subject.expired?).to be true
    end

    it "returns false when config is set to allow expired tokens" do
      CognitoTokenVerifier.config.allow_expired_tokens = true
      expect(subject.expired?).to be false
    end
  end

  describe "#valid_token_use?" do
    it "returns true when the config allows any type of token" do
      expect(subject.valid_token_use?).to be true
    end

    it "returns true when the token use matches config type" do
      CognitoTokenVerifier.config.token_use = 'id'
      expect(subject.valid_token_use?).to be true
    end

    it "returns false when the token use does not match config type" do
      CognitoTokenVerifier.config.token_use = 'access'
      expect(subject.valid_token_use?).to be false
    end
  end


  context "ALB terminated cognito" do 
    subject { CognitoTokenVerifier::Token.new(COGNITO_ALB_TEST_TOKEN) }

    before :each do
      allow_any_instance_of(RestClient).to receive(:get).and_return({})
    end

    it "provides access to the decoded token header" do
      expect(subject.header).to_not be_nil
    end

    it "sets the correct idp type" do
      expect(subject.idp_type).to be :alb
    end
  end
end
