require "spec_helper"

# rubocop:disable Style/SingleLineMethods

catch :skip_tests do
  if !ENV["APPRAISAL_INITIALIZED"] && !ENV["TRAVIS"]
    skip_because(
      __FILE__,
      "these tests only work when executed with `appraisal`",
      "rails4"
    )
  end

  begin
    require "rails"
  rescue LoadError
    skip_because(
      __FILE__,
      ["these tests only work when executed with Rails 4 loaded,",
       "and Rails was not available at all!"],
      "rails4"
    )
  end

  rails_version = ""
  begin
    rails_version = Rails.version
  rescue
    rails_version = ""
  end
  if rails_version < "4.0" || rails_version >= "5.0"
    skip_because(
      __FILE__,
      ["these tests only work when executed with Rails 4 loaded,",
       "and Rails #{rails_version} was found."],
      "rails4"
    )
  end

  context "Rails 4 application" do
    before :context do
      undefine DotenvHaiku, :App
      require "dotenv-haiku/to_load/rails4"
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
            # Dummy Rails methods
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
            # Dummy Rails methods
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
            # Dummy Rails methods
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
            # Dummy Rails methods
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

# rubocop:enable Style/SingleLineMethods
