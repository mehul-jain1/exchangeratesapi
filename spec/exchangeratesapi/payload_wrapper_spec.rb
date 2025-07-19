# frozen_string_literal: true

require "spec_helper"

RSpec.describe ExchangeRatesAPI::PayloadWrapper do
  let(:success_data) do
    {
      "success" => true,
      "timestamp" => 1_641_600_000,
      "base" => "USD",
      "date" => "2022-01-01",
      "rates" => {
        "EUR" => 0.85,
        "GBP" => 0.73
      }
    }
  end

  let(:error_data) do
    {
      "success" => false,
      "error" => {
        "code" => 101,
        "info" => "No API key was supplied"
      }
    }
  end

  describe "#initialize" do
    it "wraps the data" do
      wrapper = described_class.new(success_data)
      expect(wrapper.data).to eq(success_data)
    end
  end

  describe "#success?" do
    it "returns true when success is true" do
      wrapper = described_class.new(success_data)
      expect(wrapper.success?).to be true
    end

    it "returns false when success is false" do
      wrapper = described_class.new(error_data)
      expect(wrapper.success?).to be false
    end
  end

  describe "#base" do
    it "returns the base currency" do
      wrapper = described_class.new(success_data)
      expect(wrapper.base).to eq("USD")
    end
  end

  describe "#date" do
    it "returns the date" do
      wrapper = described_class.new(success_data)
      expect(wrapper.date).to eq("2022-01-01")
    end
  end

  describe "#rates" do
    it "returns the rates hash" do
      wrapper = described_class.new(success_data)
      expect(wrapper.rates).to eq({ "EUR" => 0.85, "GBP" => 0.73 })
    end

    it "returns empty hash when rates is nil" do
      data_without_rates = success_data.merge("rates" => nil)
      wrapper = described_class.new(data_without_rates)
      expect(wrapper.rates).to eq({})
    end
  end

  describe "#timestamp" do
    it "returns the timestamp" do
      wrapper = described_class.new(success_data)
      expect(wrapper.timestamp).to eq(1_641_600_000)
    end
  end

  describe "#historical?" do
    it "returns true when historical is true" do
      historical_data = success_data.merge("historical" => true)
      wrapper = described_class.new(historical_data)
      expect(wrapper.historical?).to be true
    end

    it "returns false when historical is false or not present" do
      wrapper = described_class.new(success_data)
      expect(wrapper.historical?).to be false
    end
  end

  describe "#error?" do
    it "returns true when error is present" do
      wrapper = described_class.new(error_data)
      expect(wrapper.error?).to be true
    end

    it "returns false when error is not present" do
      wrapper = described_class.new(success_data)
      expect(wrapper.error?).to be false
    end
  end

  describe "#error_info" do
    it "returns error information when error is present" do
      wrapper = described_class.new(error_data)
      expect(wrapper.error_info).to eq({
        "code" => 101,
        "message" => "No API key was supplied"
      })
    end

    it "returns nil when error is not present" do
      wrapper = described_class.new(success_data)
      expect(wrapper.error_info).to be_nil
    end
  end

  describe "#to_h" do
    it "returns the original data hash" do
      wrapper = described_class.new(success_data)
      expect(wrapper.to_h).to eq(success_data)
    end
  end

  describe "#to_json" do
    it "returns JSON representation of the data" do
      wrapper = described_class.new(success_data)
      expect(wrapper.to_json).to eq(success_data.to_json)
    end
  end

  describe "method_missing" do
    it "delegates unknown methods to the data hash" do
      wrapper = described_class.new(success_data)
      expect(wrapper["success"]).to be true
      expect(wrapper["base"]).to eq("USD")
    end
  end

  describe "respond_to_missing?" do
    it "responds to methods that the data hash responds to" do
      wrapper = described_class.new(success_data)
      expect(wrapper.respond_to?(:[])).to be true
      expect(wrapper.respond_to?(:keys)).to be true
    end
  end
end 