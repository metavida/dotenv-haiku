require "spec_helper"

catch :skip_tests do

  if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
    puts "Skipped #{__FILE__} because these tests only work when executed with `appraisal`"
    puts "   appraisal rails3 rake spec"
    throw :skip_tests
  end

  rails_version = ''
  begin
    require "rails"
    rails_version = Rails.version
  rescue LoadError
  rescue
  end
  if rails_version.empty?
    puts "Skipped #{__FILE__} because these tests only work when executed with Rails 3 loaded, and Rails was not loaded at all!"
    puts "   appraisal rails3 rake spec"
    throw :skip_tests
  elsif rails_version < "3.0" || rails_version >= "4.0"
    puts "Skipped #{__FILE__} because these tests only work when executed with Rails 3 loaded, and Rails #{rails_version} was found"
    puts "   appraisal rails3 rake spec"
    throw :skip_tests
  end

context "Rails 3 application" do
  before :context do
    undefine DotenvHaiku, :App
    require "dotenv-haiku/to_load/rails3"
  end

  describe "DotenvHaiku::App" do
    describe ".load" do
      def app_env_arg
        "app_env_arg"
      end

      def app_root_arg
        "app_root_arg"
      end

      context "with no Rails object" do
        before :context do
          module ::Rails
            def self.env; fail NameError; end
            def self.root; fail NameError; end
          end
        end

        it "should raise an error with no arguments" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect {
            DotenvHaiku::App.load
          }.to raise_error(DotenvHaiku::App::NoAppEnvFound)
        end
        it "should raise an error with only an :app_root argument" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect {
            DotenvHaiku::App.load(:app_root => app_root_arg)
          }.to raise_error(DotenvHaiku::App::NoAppEnvFound)
        end
        it "should raise an error with only an :app_env argument" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect {
            DotenvHaiku::App.load(:app_env => app_env_arg)
          }.to raise_error(DotenvHaiku::App::NoAppRootFound)
        end
        it "should use :app_env & :app_root arguments" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(app_env_arg),
                :app_root => app_root_arg
              )
            )

          DotenvHaiku::App.load(
            :app_env => app_env_arg,
            :app_root => app_root_arg
          )
        end
      end

      context "with Rails.env only" do
        before(:context) do
          module ::Rails
            def self.env; "via_rails_env"; end
            def self.root; fail NoMethodError; end
          end
        end
        it "should raise an error with no arguments" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect {
            DotenvHaiku::App.load
          }.to raise_error(DotenvHaiku::App::NoAppRootFound)
        end
        it "should raise an error with only an :app_env argument" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect {
            DotenvHaiku::App.load
          }.to raise_error(DotenvHaiku::App::NoAppRootFound)
        end
        it "should use the :app_root argument" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(Rails.env),
                :app_root => app_root_arg
              )
            )

          DotenvHaiku::App.load(
            :app_root => app_root_arg
          )
        end
        it "should use :app_env & :app_root arguments" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(app_env_arg),
                :app_root => app_root_arg
              )
            )

          DotenvHaiku::App.load(
            :app_env => app_env_arg,
            :app_root => app_root_arg
          )
        end
      end

      context "with Rails.root only" do
        before :context do
          module ::Rails
            def self.env; fail NoMethodError; end
            def self.root; "via_rails_root"; end
          end
        end

        it "should raise an error with no arguments" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect {
            DotenvHaiku::App.load
          }.to raise_error(DotenvHaiku::App::NoAppEnvFound)
        end
        it "should use :app_env argument" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(app_env_arg),
                :app_root => Rails.root
              )
            )

          DotenvHaiku::App.load(:app_env => app_env_arg)
        end
        it "should use :app_env & :app_root arguments" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(app_env_arg),
                :app_root => app_root_arg
              )
            )

          DotenvHaiku::App.load(
            :app_env => app_env_arg,
            :app_root => app_root_arg
          )
        end
      end

      context "with Rails.env and Rails.root" do
        before :context do
          module ::Rails
            def self.env; "via_rails_env"; end
            def self.root; "via_rails_root"; end
          end
        end

        it "should work with no arguments" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(Rails.env),
                :app_root => Rails.root
              )
            )

          DotenvHaiku::App.load
        end

        it "should use :app_env & :app_root arguments" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(app_env_arg),
                :app_root => app_root_arg
              )
            )

          DotenvHaiku::App.load(
            :app_env => app_env_arg,
            :app_root => app_root_arg
          )
        end
      end
    end
  end
end

end