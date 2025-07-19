# frozen_string_literal: true

module ExchangeRatesAPI
  class PayloadWrapper
    attr_reader :data

    def initialize(data)
      @data = data
    end

    def success?
      data["success"] == true
    end

    def base
      data["base"]
    end

    def date
      data["date"]
    end

    def rates
      data["rates"] || {}
    end

    def timestamp
      data["timestamp"]
    end

    def historical?
      data["historical"] == true
    end

    def error?
      !data["error"].nil?
    end

    def error_info
      return nil unless error?
      {
        "code" => data["error"]["code"],
        "message" => data["error"]["info"]
      }
    end

    def to_h
      data
    end

    def to_json
      data.to_json
    end

    def method_missing(method_name, *args, &block)
      if data.respond_to?(method_name)
        data.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      data.respond_to?(method_name) || super
    end
  end
end 