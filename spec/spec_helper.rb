begin
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
rescue LoadError # rubocop:disable Lint/HandleExceptions
  # Don't fail hard if this gem isn't installed
end

require "dotenv-haiku"

RSpec.configure do |config|
  # Restore the state of ENV after each spec
  config.before { @env_keys = ENV.keys }
  config.after  { ENV.delete_if { |k, _v| !@env_keys.include?(k) } }
end

def fixture_path(name)
  File.join(File.expand_path("../fixtures", __FILE__), name)
end

RSpec::Matchers.define :a_string_inquirer do |expected|
  match do |actual|
    return true if actual.blank?
    expected ||= actual
    actual.send("#{expected}?") == true &&
      actual.send("#{expected.succ}?") == false
  end
end

def override_env(new_vals = {})
  orig_env = {}
  ENV.each { |key, val| orig_env[key] = val }
  new_vals.each { |key, val| ENV[key] = val }
  yield
ensure
  new_vals.each { |key, _| ENV[key] = nil }
  orig_env.each { |key, val| ENV[key] = val }
end
