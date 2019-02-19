describe CognitoTokenVerifier do
  it "has a version number" do
    expect(CognitoTokenVerifier::VERSION).not_to be nil
  end

  describe ".config" do
    it "returns a configuration object" do
      expect(CognitoTokenVerifier.config).to be_a(CognitoTokenVerifier::Config)
    end
  end

  describe ".configure" do
    it "saves the configuration as described" do
      CognitoTokenVerifier.configure do |config|
        config.user_pool_id = "test_user_pool"
        config.aws_region = "us-west-2"
      end

      expect(CognitoTokenVerifier.config.user_pool_id).to eq("test_user_pool")
    end
  end
end
