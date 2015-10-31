# Changelog

## Unreleased

### New

* Generic app support now looks for `ENV['RACK_ENV']`, `ENV['RAILS_ENV']`, `ENV['APP_ENV']` values.
* You can always override `:env`, and `:root` values, regardless of the version of Rails (or not-Rails) that you use.

### Breaking Changes

* Fails hard in Rails 1 apps if there is no `RAILS_ROOT` constant defined.

## 0.2.0 - 2015-04-20

### Breaking Changes

* Now use `require "dotenv-haiku"` instead of `require "dotenv/rails"`
* Now use `DotenvHaiku.load` instead of `Dotenv::Railtie.load`

### Changes

* Start with a clean branch (completely separate from the bkeepers/dotenv project)

## 0.1.0 - 2015-04-17

### New

* Added dotenv-haiku to a fork of bkeepers/dotenv
* `require dotenv/rails` now loads code specific to the current version of Rails
* Dotenv::Railtie.load
  * loads `.env.custom` in development environments
  * raises an error of `.env.#{app_env}` doesn't exist (unless in a development or test environment)
