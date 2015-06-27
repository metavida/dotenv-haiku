# Almost identical to v2.0.1 dotenv/rails.rb
# https://github.com/bkeepers/dotenv/blob/v2.0.1/lib/dotenv/rails.rb

require "dotenv"
require "rails/railtie"
require "active_support"

Dotenv.instrumenter = ActiveSupport::Notifications

# Watch all loaded env files with Spring
begin
  require "spring/watcher"
  ActiveSupport::Notifications.subscribe(/^dotenv/) do |*args|
    event = ActiveSupport::Notifications::Event.new(*args)
    Spring.watch event.payload[:env].filename if Rails.application
  end
rescue LoadError # rubocop:disable Lint/HandleExceptions
  # Spring is not available
end

class DotenvHaiku
  # Dotenv Railtie for using Dotenv to load environment from a file into
  # Rails applications
  class App < Rails::Railtie
    class NoAppEnvFound < RuntimeError; end
    class NoAppRootFound < RuntimeError; end

    config.before_configuration { load }

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
      ::ActiveSupport::StringInquirer.new(
        options[:app_env] || default_app_env
      )
    end

    # Returns the given :app_root or falls back to the default
    def app_root
      options[:app_root] || default_root
    end

    def default_app_env
      ::Rails.env
    rescue NameError
      raise NoAppEnvFound, "No RAILS_ENV constant was defined"
    end

    # Internal: `Rails.root` is nil in Rails 4.1 before the application is
    # initialized, so this falls back to the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def default_root
      root = ::Rails.root || ENV["RAILS_ROOT"]
      root || (fail NoAppRootFound, "No RAILS_ROOT constant was defined")
    rescue NameError
      raise NoAppRootFound, "No RAILS_ROOT constant was defined"
    end
  end
end
