require "dotenv-haiku/string_inquirer_backport"
require "dotenv-haiku/app/base"

class DotenvHaiku
  # Dotenv Railtie for using Dotenv to load environment from a file into
  # Rails application
  class App
    class NoAppEnvFound < RuntimeError; end
    class NoAppRootFound < RuntimeError; end

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

    def default_app_env
      ::RAILS_ENV
    rescue NameError
      raise NoAppEnvFound, "No RAILS_ENV constant was defined"
    end

    def default_root
      ::RAILS_ROOT
    rescue NameError
      raise NoAppRootFound, "No RAILS_ROOT constant was defined"
    end
  end
end
