require "spec_helper"
require "config_manager"

describe ConfigManager::YAML do
  let(:namespace) { "test" }
  let(:config)    {
    { "test_key" => "test_value" }
  }

  before { allow(YAML).to receive(:load_file).and_return(config) }

  describe ".get" do
    context "when namespace was loaded" do
      before { described_class.load(namespace) }

      it "returns the configuration data for the specified namespace" do
        expect(described_class.get(namespace)).to eq(config)
      end
    end

    context "when namespace wasn\'t loaded" do
      it "returns nil" do
        expect(described_class.get('other')).to be_nil
      end
    end
  end
end
