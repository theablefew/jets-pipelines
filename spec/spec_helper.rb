require "bundler/setup"
require "pipelines"

module Helpers

  def json_file(path)
    JSON.load(IO.read(path))
  end

  def yaml_file(path)
    YAML.load_file(path)
  end
end
RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.include Helpers
end