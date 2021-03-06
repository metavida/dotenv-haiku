# Changelog

## 0.2.1 - 2015-10-30

### Fixes

* Fix Rails 4 loader to work with Rails 4.1.x

## 0.2.0 - 2015-06-22

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
