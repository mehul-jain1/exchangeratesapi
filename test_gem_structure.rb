#!/usr/bin/env ruby
# frozen_string_literal: true

# Simple test script to validate gem structure
# Run this with: ruby test_gem_structure.rb

require 'json'

def check_file_exists(path, description)
  if File.exist?(path)
    puts "✓ #{description}: #{path}"
    true
  else
    puts "✗ #{description}: #{path} (MISSING)"
    false
  end
end

def check_directory_exists(path, description)
  if Dir.exist?(path)
    puts "✓ #{description}: #{path}"
    true
  else
    puts "✗ #{description}: #{path} (MISSING)"
    false
  end
end

puts "=== Exchange Rates API Gem Structure Validation ===\n"

# Check essential files
essential_files = [
  ['exchangeratesapi.gemspec', 'Gemspec file'],
  ['lib/exchangeratesapi.rb', 'Main gem file'],
  ['lib/exchangeratesapi/version.rb', 'Version file'],
  ['lib/exchangeratesapi/client.rb', 'Client class'],
  ['lib/exchangeratesapi/errors.rb', 'Error classes'],
  ['lib/exchangeratesapi/payload_wrapper.rb', 'Payload wrapper'],
  ['README.md', 'README documentation'],
  ['CHANGELOG.md', 'Changelog'],
  ['LICENSE', 'License file'],
  ['Gemfile', 'Gemfile'],
  ['Rakefile', 'Rakefile'],
  ['.rubocop.yml', 'RuboCop configuration'],
  ['.gitignore', 'Git ignore file']
]

# Check essential directories
essential_dirs = [
  ['lib/exchangeratesapi', 'Gem lib directory'],
  ['spec', 'Test directory'],
  ['spec/exchangeratesapi', 'Gem test directory'],
  ['bin', 'Bin directory'],
  ['examples', 'Examples directory']
]

puts "Checking essential files:"
file_results = essential_files.map { |file, desc| check_file_exists(file, desc) }

puts "\nChecking essential directories:"
dir_results = essential_dirs.map { |dir, desc| check_directory_exists(dir, desc) }

puts "\nChecking gemspec content:"
begin
  gemspec_content = File.read('exchangeratesapi.gemspec')
  if gemspec_content.include?('ExchangeRatesAPI::VERSION')
    puts "✓ Gemspec references version correctly"
  else
    puts "✗ Gemspec missing version reference"
  end
  
  if gemspec_content.include?('httparty')
    puts "✓ Gemspec includes HTTParty dependency"
  else
    puts "✗ Gemspec missing HTTParty dependency"
  end
rescue => e
  puts "✗ Error reading gemspec: #{e.message}"
end

puts "\nChecking main gem file:"
begin
  main_gem_content = File.read('lib/exchangeratesapi.rb')
  if main_gem_content.include?('require_relative')
    puts "✓ Main gem file includes relative requires"
  else
    puts "✗ Main gem file missing relative requires"
  end
rescue => e
  puts "✗ Error reading main gem file: #{e.message}"
end

puts "\n=== Validation Summary ==="
total_files = file_results.count(true)
total_dirs = dir_results.count(true)
puts "Files found: #{total_files}/#{essential_files.length}"
puts "Directories found: #{total_dirs}/#{essential_dirs.length}"

if total_files == essential_files.length && total_dirs == essential_dirs.length
  puts "\n🎉 All essential files and directories are present!"
  puts "The gem structure appears to be complete and ready for testing."
else
  puts "\n⚠️  Some files or directories are missing. Please check the output above."
end

puts "\n=== Next Steps ==="
puts "1. Install Ruby: sudo apt install ruby ruby-bundler"
puts "2. Install dependencies: bundle install"
puts "3. Run tests: bundle exec rspec"
puts "4. Build gem: gem build exchangeratesapi.gemspec"
puts "5. Install gem locally: gem install exchangeratesapi-0.1.0.gem" 