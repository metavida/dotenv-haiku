require "dotenv-haiku/string_inquirer_backport"
require "dotenv-haiku/app/base"

class DotenvHaiku
  # Tries to determine the application's environment
  # and the root directory containing .env files.
  class App
    # The type of App that DotenvHaiku thinks you're building
    DETECTED = "Non-Rails"

    class NoAppEnvFound < RuntimeError; end

    include AppBase

    private

    # Returns a StringInquirer-wrapped string
    # Uses the given :app_env of falls back to the default
    def app_env
      StringInquirerBackport.new(options[:app_env] || default_app_env)
    end

    # Returns the given :app_root or falls back to the default
    def app_root
      options[:app_root] || default_root
    end

    # Try the following environment variables (in order)
    # use the first one that isn't empty:
    # * `RACK_ENV`
    # * `RAILS_ENV`
    # * `APP_ENV`
    #
    # Raise an error if all of the above are blank.
    def default_app_env
      env_key = %w(
        RACK_ENV
        RAILS_ENV
        APP_ENV
      ).detect { |key| !ENV[key].to_s.empty? }

      if env_key && ENV[env_key]
        ENV[env_key]
      else
        fail NoAppEnvFound, 'Expected ENV["RACK_ENV"] be a non-blank string.'
      end
    end

    # Try the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def default_root
      ENV["RAILS_ROOT"] || Dir.pwd
    end
  end
end