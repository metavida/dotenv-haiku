# If you use gems that require environment variables to be set before they are
# loaded, then list `dotenv-haiku` in the `Gemfile` before those other gems and
# require `dotenv-haiku/now`.
#
#     gem "dotenv-haiku", :require => "dotenv-haiku/now"
#     gem "gem-that-requires-env-variables"
#

require "dotenv-haiku"
DotenvHaiku.load
