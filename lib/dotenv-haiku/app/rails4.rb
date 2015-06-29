# Almost identical to v2.0.1 dotenv/rails.rb
# https://github.com/bkeepers/dotenv/blob/v2.0.1/lib/dotenv/rails.rb

require "dotenv-haiku/app/base"

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

    include AppBase

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
    # initialized, so this falls back to the the current working directory.
    def default_root
      root = nil

      begin
        root = ::Rails.root
      rescue NameError # rubocop:disable Lint/HandleExceptions
      end

      root ||= Dir.pwd
      root || (fail NoAppRootFound, "No Rails.root was available defined")
    end
  end
end
