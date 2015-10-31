class DotenvHaiku
  # A place to DRY up code
  # used by all of our DotenvHaiku::App types.
  module AppBase
    def self.included(base)
      base.class_eval do
        attr_accessor :options
      end
      base.extend ClassMethods
    end

    # Manually call `Dotenv::Railtie.load` in your app's config
    def load
      Dotenv.load(*to_load)
    end

    def to_load
      DotenvHaiku::Loader.new(
        :app_env  => app_env,
        :app_root => app_root
      )
    end

    # Common Class methods
    module ClassMethods
      # Rails uses `#method_missing` to delegate all class methods to the
      # instance, which means `Kernel#load` could get called.
      # We don't want that.
      def load(options = {})
        instance = new
        instance.options = options
        instance.load
      end
    end
  end
end
