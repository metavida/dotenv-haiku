#!/usr/bin/env rake

begin
  require "bundler/gem_tasks"
  require "bundler/setup"
rescue LoadError
  puts "Bundler not available. Install it with: gem install bundler"
end

require "rspec/core/rake_task"

desc "Run all specs"
RSpec::Core::RakeTask.new(:spec) do |t|
  t.rspec_opts = %w(--color)
  t.verbose = false
end

task :default => :spec
