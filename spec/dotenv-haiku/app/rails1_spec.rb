require "spec_helper"

context "Rails 1 application" do
  before :context do
    undefine DotenvHaiku, :App
    require "dotenv-haiku/app/rails1"
  end

  describe "DotenvHaiku::App" do
    describe ".load" do
      def app_env_arg
        "app_env_arg"
      end

      def app_root_arg
        "app_root_arg"
      end

      context "with empty RAILS_ENV and RAILS_ROOT" do
        before :context do
          undefine Object, :RAILS_ENV
          undefine Object, :RAILS_ROOT
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

      context "with RAILS_ENV only" do
        before(:context) do
          undefine Object, :RAILS_ENV
          undefine Object, :RAILS_ROOT
          RAILS_ENV = "via_rails_env"
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
                :app_env => a_string_inquirer(RAILS_ENV),
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

      context "with RAILS_ROOT only" do
        before :context do
          undefine Object, :RAILS_ENV
          undefine Object, :RAILS_ROOT
          ::RAILS_ROOT = "via_rails_root"
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
                :app_root => RAILS_ROOT
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

      context "with RAILS_ENV and RAILS_ROOT" do
        before :context do
          undefine Object, :RAILS_ENV
          undefine Object, :RAILS_ROOT
          ::RAILS_ENV = "via_rails_env"
          ::RAILS_ROOT = "via_rails_root"
        end

        it "should work with no arguments" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(RAILS_ENV),
                :app_root => RAILS_ROOT
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
