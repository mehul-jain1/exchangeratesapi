# frozen_string_literal: true

require "spec_helper"

RSpec.describe ExchangeRatesAPI::Client do
  let(:api_key) { "test_api_key" }
  let(:client) { described_class.new(api_key) }

  describe "#initialize" do
    it "sets the API key" do
      expect(client.api_key).to eq(api_key)
    end

    it "uses default base URL" do
      expect(client.base_url).to eq("https://api.exchangeratesapi.io/v1")
    end

    it "uses custom base URL when provided" do
      custom_client = described_class.new(api_key, "https://custom.api.com/v1")
      expect(custom_client.base_url).to eq("https://custom.api.com/v1")
    end

    it "reads API key from environment variable when not provided" do
      allow(ENV).to receive(:fetch).with("EXCHANGE_RATE_API_KEY", nil).and_return("env_api_key")
      allow(ENV).to receive(:fetch).with("EXCHANGE_RATE_API_BASE", "https://api.exchangeratesapi.io/v1").and_return("https://api.exchangeratesapi.io/v1")
      env_client = described_class.new
      expect(env_client.api_key).to eq("env_api_key")
    end
  end

  describe "#latest" do
    it "creates a client instance" do
      expect(client).to be_a(ExchangeRatesAPI::Client)
    end

    it "has correct API key" do
      expect(client.api_key).to eq(api_key)
    end

    it "has correct base URL" do
      expect(client.base_url).to eq("https://api.exchangeratesapi.io/v1")
    end
  end

  describe "#historical" do
    it "is a method of the client" do
      expect(client).to respond_to(:historical)
    end
  end

  describe "#exchange_rate" do
    it "is a method of the client" do
      expect(client).to respond_to(:exchange_rate)
    end
  end

  describe "#currencies" do
    it "is a method of the client" do
      expect(client).to respond_to(:currencies)
    end
  end

  describe "#convert" do
    it "is a method of the client" do
      expect(client).to respond_to(:convert)
    end
  end

  describe "error handling" do
    context "when API returns an error" do
      let(:error_response) do
        {
          "success" => false,
          "error" => {
            "code" => 101,
            "info" => "No API key was supplied"
          }
        }
      end

      before do
        stub_request(:get, /api\.exchangeratesapi\.io\/v1\/latest/)
          .to_return(status: 401, body: error_response.to_json)
      end

      it "raises AuthenticationError for 401 status" do
        expect { client.latest }.to raise_error(ExchangeRatesAPI::AuthenticationError)
      end
    end

    context "when server returns 5xx error" do
      before do
        stub_request(:get, /api\.exchangeratesapi\.io\/v1\/latest/)
          .to_return(status: 500, body: "Internal Server Error")
      end

      it "raises ServerError for 5xx status" do
        expect { client.latest }.to raise_error(ExchangeRatesAPI::ServerError)
      end
    end

    context "when rate limit is exceeded" do
      before do
        stub_request(:get, /api\.exchangeratesapi\.io\/v1\/latest/)
          .to_return(status: 429, body: "Rate limit exceeded")
      end

      it "raises RateLimitError for 429 status" do
        expect { client.latest }.to raise_error(ExchangeRatesAPI::RateLimitError)
      end
    end
  end
end 