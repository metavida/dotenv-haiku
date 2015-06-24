require "dotenv-haiku/string_inquirer_backport"

class DotenvHaiku
  # Tries to determine the application's environment
  # and the root directory containing .env files.
  class App
    class NoAppEnvFound < RuntimeError; end

    attr_accessor :options

    def self.load(options = {})
      instance = new
      instance.options = options
      instance.load
    end

    def load
      Dotenv.load(*to_load)
    end

    def to_load
      DotenvHaiku::Loader.new(
        :app_env  => app_env,
        :app_root => app_root
      )
    end

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
