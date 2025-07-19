# frozen_string_literal: true

require_relative '../lib/exchangeratesapi'

# Initialize the client
# You can either pass the API key directly or set it as an environment variable
client = ExchangeRatesAPI.new('your_api_key_here')
# Or: client = ExchangeRatesAPI.new

puts "=== Exchange Rates API Client Example ===\n"

begin
  # Get latest exchange rates
  puts "1. Getting latest USD to EUR exchange rate..."
  response = client.latest(from_currency: 'USD', to_currency: 'EUR')
  
  if response.success?
    puts "   Success! USD to EUR rate: #{response.rates['EUR']}"
    puts "   Date: #{response.date}"
    puts "   Base currency: #{response.base}"
  else
    puts "   Error: #{response.error_info['message']}"
  end

  # Get historical rates
  puts "\n2. Getting historical USD to EUR rate for 2024-01-01..."
  historical_response = client.historical('2024-01-01', from_currency: 'USD', to_currency: 'EUR')
  
  if historical_response.success?
    puts "   Success! Historical USD to EUR rate: #{historical_response.rates['EUR']}"
    puts "   Date: #{historical_response.date}"
    puts "   Is historical: #{historical_response.historical?}"
  end

  # Convert currency
  puts "\n3. Converting 100 USD to EUR..."
  conversion = client.convert(amount: 100, from_currency: 'USD', to_currency: 'EUR')
  
  puts "   #{conversion[:amount]} #{conversion[:from_currency]} = #{conversion[:converted_amount]} #{conversion[:to_currency]}"
  puts "   Exchange rate: #{conversion[:rate]}"
  puts "   Date: #{conversion[:date]}"

  # Get supported currencies
  puts "\n4. Getting supported currencies..."
  currencies_response = client.currencies
  
  if currencies_response.success?
    puts "   Found #{currencies_response.symbols.keys.count} supported currencies"
    puts "   Sample currencies:"
    currencies_response.symbols.first(5).each do |code, info|
      puts "     #{code}: #{info['description']}"
    end
  end

  # Get exchange rate for specific currencies
  puts "\n5. Getting USD to EUR exchange rate using exchange_rate method..."
  rate_response = client.exchange_rate(from_currency: 'USD', to_currency: 'EUR')
  
  if rate_response.success?
    puts "   USD to EUR rate: #{rate_response.rates['EUR']}"
  end

rescue ExchangeRatesAPI::AuthenticationError => e
  puts "Authentication error: #{e.message}"
rescue ExchangeRatesAPI::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
rescue ExchangeRatesAPI::ServerError => e
  puts "Server error: #{e.message}"
rescue ExchangeRatesAPI::RequestError => e
  puts "Request error: #{e.message}"
rescue => e
  puts "Unexpected error: #{e.message}"
end

puts "\n=== Example completed ===" 