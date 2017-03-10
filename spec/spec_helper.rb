require "bundler/setup"
require "webmock/rspec"
require "typed_form"
require "byebug"

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def data_api_json(filename)
  File.read("spec/fixtures/data_api/#{filename}.json")
end

def webhook_json(filename)
  File.read("spec/fixtures/webhooks/#{filename}.json")
end
