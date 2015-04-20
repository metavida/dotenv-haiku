require "dotenv"
require "dotenv-haiku/loader"

# Load .env files
# and for supported versions of Rails
# configure Dotenv to automatically load & reload
class DotenvHaiku
  class << self
    # Load all appropriate .env files
    #
    # Available options:
    # * :app_name: A Sting representing the app's name
    #    Default: 'Rails'
    # * :version: A String representing the app's version
    #    Default: Rails.version
    # * :env: An ActiveSupport::StringInquirer instance.
    #    If `false`, no ".env.#{app_env}" file is loaded.
    #    Default: Rails.env
    # * :root: A full path to the location of the .env files
    #    Default: Rails.root
    def load(options = {})
      @options = options
      set_up_app unless defined?(DotenvHaiku::App)

      DotenvHaiku::App.load
    end

    def options
      @options ||= {}
    end

    private

    def set_up_app
      case app_name
      when "Rails"
        require_rails_app
      else
        require_generic_app
      end
    end

    def require_rails_app
      case app_version
      when /^1/ then require File.join(base, "rails1")
      when /^2/ then fail "Rails 2 is not yet supported"
      when /^3/ then require File.join(base, "rails3")
      when /^4/ then require File.join(base, "rails4")
      else;          require_generic_app
      end
    end

    def require_generic_app
      require File.join(base, "generic")
    end

    def app_name
      options[:app_name] || "Rails"
    end

    def app_version
      return options[:app_version] if options[:app_version]

      begin
        Rails.version
      rescue
        "no version"
      end
    end

    def base
      "dotenv-haiku/to_load"
    end
  end
end
