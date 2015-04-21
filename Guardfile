guard "bundler" do
  watch("Gemfile")
end

group :red_green_refactor, :halt_on_fail => true do
  guard "rspec", :cmd => "bundle exec rspec" do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^spec/spec_helper.rb$}) { "spec" }
    watch(%r{^lib/(.+)\.rb$}) do |m|
      path_parts = File.split(m[1])
      path_parts.last.gsub!("-", "_")
      path_parts.last.gsub!(/$/, "_spec.rb")
      f = File.join("spec", *path_parts)
      puts f.inspect
      f
    end
  end

  guard :rubocop, :cmd => "bundle exec rubocop" do
    watch(/.+\.rb$/)
    watch(%r{(?:.+/)?\.rubocop\.yml$}) { |m| File.dirname(m[0]) }
  end
end
