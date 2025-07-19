# frozen_string_literal: true

require_relative "lib/exchangeratesapi/version"

Gem::Specification.new do |spec|
  spec.name = "exchangeratesapi"
  spec.version = ExchangeRatesAPI::VERSION
  spec.authors = ["Mehul Jain"]
  spec.email = ["mehuljain160@gmail.com"]

  spec.summary = "Ruby client for the Exchange Rates API"
  spec.description = "A simple and efficient Ruby client for the Exchange Rates API (exchangeratesapi.io)"
  spec.homepage = "https://github.com/mehul-jain1/exchangeratesapi"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files = Dir.glob("{lib}/**/*") + %w[README.md LICENSE CHANGELOG.md]
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty", "~> 0.21"
  spec.add_dependency "json", "~> 2.6"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "webmock", "~> 3.18"
  spec.add_development_dependency "vcr", "~> 6.0"
  spec.add_development_dependency "rubocop", "~> 1.0"
end 