# Exchange Rates API Client

A simple and efficient Ruby client for the [Exchange Rates API](https://exchangeratesapi.io/).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'exchangeratesapi'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install exchangeratesapi
```

## Usage

### Basic Setup

```ruby
require 'exchangeratesapi'

# Initialize with API key
client = ExchangeRatesAPI.new('your_api_key_here')

# Or use environment variable
ENV['EXCHANGE_RATE_API_KEY'] = 'your_api_key_here'
client = ExchangeRatesAPI.new
```

### Get Latest Exchange Rates

```ruby
# Get latest rates with USD as base currency
response = client.latest(from_currency: 'USD', to_currency: 'EUR,GBP')

puts response.success?        # => true
puts response.base           # => "USD"
puts response.date           # => "2024-01-15"
puts response.rates['EUR']   # => 0.85
puts response.rates['GBP']   # => 0.73

# Get all available rates (no to_currency specified)
response = client.latest(from_currency: 'USD')
```

### Get Historical Exchange Rates

```ruby
# Get rates for a specific date
response = client.historical('2024-01-01', from_currency: 'USD', to_currency: 'EUR')

puts response.historical?    # => true
puts response.date          # => "2024-01-01"
puts response.rates['EUR']  # => 0.84
```

### Currency Conversion

```ruby
# Convert 100 USD to EUR
result = client.convert(amount: 100, from_currency: 'USD', to_currency: 'EUR')

puts result[:amount]           # => 100
puts result[:from_currency]    # => "USD"
puts result[:to_currency]      # => "EUR"
puts result[:rate]             # => 0.85
puts result[:converted_amount] # => 85.0
puts result[:date]             # => "2024-01-15"

# Convert with historical rates
result = client.convert(
  amount: 100,
  from_currency: 'USD',
  to_currency: 'EUR',
  date: '2024-01-01'
)
```

### Get Supported Currencies

```ruby
response = client.currencies

response.symbols.each do |code, info|
  puts "#{code}: #{info['description']}"
end
# => USD: United States Dollar
# => EUR: Euro
# => GBP: British Pound Sterling
# ...
```

### Get Exchange Rate for Specific Currencies

```ruby
# Get current rate
response = client.exchange_rate(from_currency: 'USD', to_currency: 'EUR')

# Get historical rate
response = client.exchange_rate(
  from_currency: 'USD',
  to_currency: 'EUR',
  date: '2024-01-01'
)
```

### Advanced Features (Paid Plans)

#### Time Series Data

```ruby
response = client.time_series(
  start_date: '2024-01-01',
  end_date: '2024-01-31',
  from_currency: 'USD',
  to_currency: 'EUR'
)
```

#### Fluctuation Data

```ruby
response = client.fluctuation(
  start_date: '2024-01-01',
  end_date: '2024-01-31',
  from_currency: 'USD',
  to_currency: 'EUR'
)
```

## Error Handling

The gem provides specific error classes for different types of errors:

```ruby
begin
  response = client.latest
rescue ExchangeRatesAPI::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue ExchangeRatesAPI::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
rescue ExchangeRatesAPI::ServerError => e
  puts "Server error: #{e.message}"
rescue ExchangeRatesAPI::RequestError => e
  puts "Request error: #{e.message}"
end
```

## Response Wrapper

All API responses are wrapped in a `PayloadWrapper` object that provides convenient access to response data:

```ruby
response = client.latest(from_currency: 'USD', to_currency: 'EUR')

# Direct access to response data
response.success?     # => true/false
response.base        # => base currency
response.date        # => date of rates
response.rates       # => hash of rates
response.timestamp   # => Unix timestamp
response.historical? # => true for historical data

# Check for errors
if response.error?
  error_info = response.error_info
  puts "Error: #{error_info['message']} (Code: #{error_info['code']})"
end

# Convert to hash or JSON
response.to_h        # => original response hash
response.to_json     # => JSON string
```

## Configuration

### Environment Variables

- `EXCHANGE_RATE_API_KEY`: Your API key from exchangeratesapi.io
- `EXCHANGE_RATE_API_BASE`: Custom base URL (optional, defaults to https://api.exchangeratesapi.io/v1)

### Custom Base URL

```ruby
client = ExchangeRatesAPI.new('your_api_key', 'https://custom.api.com/v1')
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/mehul/exchangeratesapi. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/mehul/exchangeratesapi/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the ExchangeRatesAPI project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/mehul/exchangeratesapi/blob/main/CODE_OF_CONDUCT.md).
