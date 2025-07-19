# frozen_string_literal: true

module ExchangeRatesAPI
  class Client
    include HTTParty
    base_uri "https://api.exchangeratesapi.io/v1"

    attr_reader :api_key, :base_url

    def initialize(api_key = nil, base_url = nil)
      @api_key = api_key || ENV.fetch("EXCHANGE_RATE_API_KEY", nil)
      @base_url = base_url || ENV.fetch("EXCHANGE_RATE_API_BASE", "https://api.exchangeratesapi.io/v1")
      
      # Set the base URI for HTTParty
      self.class.base_uri @base_url
    end

    # Get latest exchange rates
    # @param from_currency [String] Base currency (e.g., "USD")
    # @param to_currency [String] Target currency (e.g., "EUR") or comma-separated list
    # @return [PayloadWrapper] Response wrapped in PayloadWrapper
    def latest(from_currency: "EUR", to_currency: nil)
      params = { base: from_currency }
      params[:symbols] = to_currency if to_currency
      
      response = execute_request("get", "/latest", params)
      parse_and_raise_error(response) unless success_response?(response)
      PayloadWrapper.new(response.parsed_response)
    end

    # Get historical exchange rates
    # @param date [String] Date in YYYY-MM-DD format
    # @param from_currency [String] Base currency (e.g., "USD")
    # @param to_currency [String] Target currency (e.g., "EUR") or comma-separated list
    # @return [PayloadWrapper] Response wrapped in PayloadWrapper
    def historical(date, from_currency: "EUR", to_currency: nil)
      params = { base: from_currency }
      params[:symbols] = to_currency if to_currency
      
      response = execute_request("get", "/#{date}", params)
      parse_and_raise_error(response) unless success_response?(response)
      PayloadWrapper.new(response.parsed_response)
    end

    # Get exchange rate for specific currencies
    # @param from_currency [String] Base currency (e.g., "USD")
    # @param to_currency [String] Target currency (e.g., "EUR")
    # @param date [String, nil] Optional date in YYYY-MM-DD format for historical rates
    # @return [PayloadWrapper] Response wrapped in PayloadWrapper
    def exchange_rate(from_currency:, to_currency:, date: nil)
      if date
        historical(date, from_currency: from_currency, to_currency: to_currency)
      else
        latest(from_currency: from_currency, to_currency: to_currency)
      end
    end

    # Get supported currencies
    # @return [PayloadWrapper] Response wrapped in PayloadWrapper
    def currencies
      response = execute_request("get", "/symbols")
      parse_and_raise_error(response) unless success_response?(response)
      PayloadWrapper.new(response.parsed_response)
    end

    # Convert amount between currencies
    # @param amount [Numeric] Amount to convert
    # @param from_currency [String] Source currency (e.g., "USD")
    # @param to_currency [String] Target currency (e.g., "EUR")
    # @param date [String, nil] Optional date in YYYY-MM-DD format for historical rates
    # @return [Hash] Conversion result with amount and rate
    def convert(amount:, from_currency:, to_currency:, date: nil)
      response = exchange_rate(
        from_currency: from_currency,
        to_currency: to_currency,
        date: date
      )
      
      rate = response.rates[to_currency]
      raise ExchangeRatesAPI::Error.new("Rate not found for #{to_currency}") if rate.nil?
      converted_amount = amount * rate
      
      {
        amount: amount,
        from_currency: from_currency,
        to_currency: to_currency,
        rate: rate,
        converted_amount: converted_amount,
        date: response.date
      }
    end

    # Get time series data (requires paid plan)
    # @param start_date [String] Start date in YYYY-MM-DD format
    # @param end_date [String] End date in YYYY-MM-DD format
    # @param from_currency [String] Base currency (e.g., "USD")
    # @param to_currency [String] Target currency (e.g., "EUR")
    # @return [PayloadWrapper] Response wrapped in PayloadWrapper
    def time_series(start_date:, end_date:, from_currency: "EUR", to_currency:)
      params = {
        base: from_currency,
        symbols: to_currency,
        start_date: start_date,
        end_date: end_date
      }
      
      response = execute_request("get", "/timeseries", params)
      parse_and_raise_error(response) unless success_response?(response)
      PayloadWrapper.new(response.parsed_response)
    end

    # Get fluctuation data (requires paid plan)
    # @param start_date [String] Start date in YYYY-MM-DD format
    # @param end_date [String] End date in YYYY-MM-DD format
    # @param from_currency [String] Base currency (e.g., "USD")
    # @param to_currency [String] Target currency (e.g., "EUR")
    # @return [PayloadWrapper] Response wrapped in PayloadWrapper
    def fluctuation(start_date:, end_date:, from_currency: "EUR", to_currency:)
      params = {
        base: from_currency,
        symbols: to_currency,
        start_date: start_date,
        end_date: end_date
      }
      
      response = execute_request("get", "/fluctuation", params)
      parse_and_raise_error(response) unless success_response?(response)
      PayloadWrapper.new(response.parsed_response)
    end

    private

    def execute_request(method, endpoint, params = {})
      # Add API key to params if available
      params[:access_key] = api_key if api_key
      
      # Build URL with query parameters
      uri = URI("#{base_url}#{endpoint}")
      uri.query = URI.encode_www_form(params) unless params.empty?
      
      self.class.send(method, uri.to_s, headers: default_headers)
    end

    def default_headers
      { "Content-Type" => "application/json" }
    end

    def parse_and_raise_error(response)
      if response.code.to_s.start_with?("5")
        raise_error(ServerError, response)
      elsif response.code == 401
        raise_error(AuthenticationError, response)
      elsif response.code == 429
        raise_error(RateLimitError, response)
      else
        raise_error(RequestError, response)
      end
    end

    def raise_error(error_class, response)
      error_message = "Error processing request: #{response.code}"
      
      if response.parsed_response && response.parsed_response["error"]
        error_info = response.parsed_response["error"]
        error_message = "#{error_message} - #{error_info['info']} (Code: #{error_info['code']})"
      end
      
      raise error_class.new(error_message, error_response: response)
    end

    def success_response?(response)
      response.code == 200
    end
  end
end 