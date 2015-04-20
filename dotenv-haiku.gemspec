require File.expand_path("../lib/dotenv-haiku/version", __FILE__)
require "English"

Gem::Specification.new "dotenv-haiku", DotenvHaiku::VERSION do |gem|
  gem.authors       = ["Marcos Wright-Kuhns"]
  gem.email         = ["webmaster@wrightkuhns.com"]
  gem.description   = \
    gem.summary     = "Autoload dotenv with Haiku Learning-specific tweaks."
  gem.homepage      = "https://github.com/metavida/dotenv"
  gem.license       = "MIT"
  gem.files         = `git ls-files lib`\
    .split($OUTPUT_RECORD_SEPARATOR) + ["README.md", "LICENSE"]

  gem.add_dependency "dotenv"

  gem.add_development_dependency "rake"
  gem.add_development_dependency "rspec"
  gem.add_development_dependency "rubocop"
end
