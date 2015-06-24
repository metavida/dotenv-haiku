require "dotenv-haiku/string_inquirer_backport"

class DotenvHaiku
  # Dotenv Railtie for using Dotenv to load environment from a file into
  # Rails application
  class App
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

    def default_app_env
      ::RAILS_ENV
    end

    def default_root
      ::RAILS_ROOT || Dir.pwd
    rescue NameError
      Dir.pwd
    end
  end
end
