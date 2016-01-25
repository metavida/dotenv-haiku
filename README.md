[![Build Status](https://secure.travis-ci.org/metavida/dotenv-haiku.png)](https://travis-ci.org/metavida/dotenv-haiku)
[![Code Climate](https://codeclimate.com/github/metavida/dotenv-haiku/badges/gpa.svg)](https://codeclimate.com/github/metavida/dotenv-haiku)
[![Test Coverage](https://codeclimate.com/github/metavida/dotenv-haiku/badges/coverage.svg)](https://codeclimate.com/github/metavida/dotenv-haiku)

# dotenv-haiku

A replacement of for `dotenv-rails` that meets a few specific requirements

* Enforce specific load rules
  * Load the `.env.custom` file on development environments.
  * Load the `".env.#{Rails.env}"` file and **fail hard** if the file does not exist on production.
* Better supports older Rails versions and non-Rails apps.

## Installation

Add this line to the top of your application's Gemfile:

```ruby
gem 'dotenv-haiku', require: 'dotenv-haiku', git: 'git@github.com:metavida/dotenv-haiku.git'
```

And then execute:

```shell
$ bundle
```

### Rails 4

#### Note on load order

dotenv is initialized in your Rails app during the `before_configuration` callback, which is fired when the `Application` constant is defined in `config/application.rb` with `class Application < Rails::Application`. If you need it to be initialized sooner, you can manually call `Dotenv::Railtie.load`.

```ruby
# config/application.rb
Bundler.require(*Rails.groups)

Dotenv::Railtie.load

HOSTNAME = ENV['HOSTNAME']
```

If you use gems that require environment variables to be set before they are loaded, then list `dotenv-rails` in the `Gemfile` before those other gems and require `dotenv/rails-now`.

```ruby
gem 'dotenv-haiku', require: 'dotenv-haiku/now', git: 'git@github.com:metavida/dotenv-haiku.git'
gem 'gem-that-requires-env-variables'
```

### Rails 3

As early as possible in your application bootstrap process, load `.env`:

```ruby
# config/application.rb
require 'dotenv-haiku/now'
```

### Rails 1

```ruby
# config/environment.rb
# in the `Rails::Initializer.run do |config|` block
require 'dotenv-haiku/now'
```

### non-Rails

Currently, the gem depends on ActiveSupport::StringInquirer behavior, so you have 2 options

#### Include the ActiveSupport gem

```ruby
gem 'active_support'
```

And then execute:

```shell
$ bundle
```

As early as possible in your application bootstrap process, load `.env`:

```ruby
require 'active_support/string_inquirer'
require 'dotenv-haiku'
Dotenv::App.load(:app_env => ActiveSupport::StringInquirer.new(ENV["RACK_ENV"]))
# Yup, that's right. These references to "rails"
# should work, even for non-Rails apps
```

#### Emulate StringInquirer behavior

As early as possible in your application bootstrap process, load `.env`:

```ruby
class MyStringInquirer < String
  def method_missing(method_name, *arguments)
    if method_name.to_s[-1,1] == "?"
      self == method_name.to_s[0..-2]
    else
      super
    end
  end
end

require 'dotenv-haiku'
Dotenv::App.load(:app_env => MyStringInquirer.new(ENV["RACK_ENV"]))
```

## Contributing

We'd love to have you contribute to this project! The basic steps are:


1. Create a Fork on GitHub
2. Create a git branch for your changes
3. Make local changes & test them
4. Commit your changes
5. Push to the branch
6. Create new Pull Request

### Setting up your local environment

In order to run tests locally, you'll have to use the bundler and [appraisal](https://github.com/thoughtbot/appraisal) gems.

```shell
$ bundle --version || gem install bundler
$ bundle install
$ bundle exec appraisal install
```

### Running Tests

This gem is designed to work with multiple versions of Ruby and Rails. Fortunately, appraisal lets us quickly & easily run tests against multiple Rails versions.

```shell
$ bundle exec appraisal rspec
```

### Code Style

This project uses [RuboCop](http://batsov.com/rubocop/) to automatically encourage/enforce use of consistent coding style in all of the project's ruby code.

```shell
$ bundle exec rubocop
```

### Auto-running Tests & Tools

This project uses [Guard](http://guardgem.org/) to make it easy to continuously run all tests and other coding tools (like RuboCop) as you code.

```shell
$ bundle exec guard
```

Now, with guard running, you can edit any files in the project & the appropriate tests & checks will be run as you save your local changes! If you want to have guard re-run the entire test suite, just hit enter from within your guard console.
