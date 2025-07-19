# frozen_string_literal: true

require "httparty"
require "json"

require_relative "exchangeratesapi/version"
require_relative "exchangeratesapi/client"
require_relative "exchangeratesapi/errors"
require_relative "exchangeratesapi/payload_wrapper"

module ExchangeRatesAPI
  class << self
    def new(api_key = nil, base_url = nil)
      Client.new(api_key, base_url)
    end
  end
end 