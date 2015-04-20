class DotenvHaiku
  # Dotenv Railtie for using Dotenv to load environment from a file into
  # Ruby applications
  class App
    # Public: Load dotenv
    #
    # Manually call `Dotenv::Railtie.load` in your app's config
    def load(options = {})
      Dotenv.load(*to_load(options))
    end

    # Internal: Try the `RAILS_ROOT` environment variable,
    # or the current working directory.
    def root
      Pathname.new(ENV["RAILS_ROOT"] || Dir.pwd)
    end

    def to_load(options = {})
      options = {
        :app_root => root
      }.merge(options)
      DotenvHaiku::Loader.new(options)
    end

    # Rails uses `#method_missing` to delegate all class methods to the
    # instance, which means `Kernel#load` gets called here. We don't want that.
    def self.load(options = {})
      new.load(options)
    end
  end
end
