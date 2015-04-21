source "https://rubygems.org"
gemspec :name => "dotenv-haiku"

group :guard do
  gem "guard-rspec"
  gem "guard-bundler"
  gem "guard-rubocop"
  gem "rb-fsevent"
end

if RUBY_VERSION > "1.9"
  gem "codeclimate-test-reporter", :group => :test, :require => nil
end
