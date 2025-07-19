# frozen_string_literal: true

module ExchangeRatesAPI
  class Error < StandardError
    attr_reader :error_response

    def initialize(message = nil, error_response: nil)
      @error_response = error_response
      super(message || "Exchange Rates API error")
    end
  end

  class RequestError < Error
    def initialize(message = nil, error_response: nil)
      super(message, error_response: error_response)
    end
  end

  class ServerError < Error
    def initialize(message = nil, error_response: nil)
      super(message, error_response: error_response)
    end
  end

  class AuthenticationError < Error
    def initialize(message = nil, error_response: nil)
      super(message || "Authentication failed", error_response: error_response)
    end
  end

  class RateLimitError < Error
    def initialize(message = nil, error_response: nil)
      super(message || "Rate limit exceeded", error_response: error_response)
    end
  end
end 