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

def undefine(klass, const)
  klass.send(:remove_const, const) if klass.constants.include?(const)
end

def skip_because(file, message, appraisal_name)
  puts "Skipped some tests in #{file} because #{Array(message).join(' ')}"
  puts "   appraisal #{appraisal_name} rake spec"
  throw :skip_tests
end

def skip_unless_rails_between(min_version, over_max_version, file = __FILE__)
  if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
    skip_because(
      file,
      "these tests only work when executed with `appraisal`",
      "rails3"
    )
  end

  begin
    require "rails"
  rescue LoadError
    skip_because(
      file,
      ["these tests only work when executed with Rails 3 loaded,",
       "and Rails was not available at all!"],
      "rails3"
    )
  end

  rails_version = ""
  begin
    rails_version = Rails.version
  rescue
    rails_version = ""
  end

  return true if rails_version >= min_version &&
                 rails_version < over_max_version

  skip_because(
    file,
    ["these tests only work when executed with Rails #{min_version} loaded,",
     "and Rails #{rails_version} was found."],
    "rails3"
  )
end
