require "spec_helper"

puts 'start spec3'
#puts defined?(Rails).inspect
#require 'rails'
#puts defined?(Rails).inspect
#puts defined?(Rails::Railtie).inspect
#require 'rails/railtie'
#puts defined?(Rails::Railtie).inspect

context "Rails 3 application" do
  before :context do
    require 'rails/all'
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

      #context "with no Rails object" do
      #  before :context do
      #    undefine Object, :Rails
      #  end
      #
      #  it "should raise an error with no arguments" do
      #    expect(DotenvHaiku::Loader).to receive(:new).never
      #
      #    expect {
      #      DotenvHaiku::App.load
      #    }.to raise_error(DotenvHaiku::App::NoAppEnvFound)
      #  end
      #  it "should raise an error with only an :app_root argument" do
      #    expect(DotenvHaiku::Loader).to receive(:new).never
      #
      #    expect {
      #      DotenvHaiku::App.load(:app_root => app_root_arg)
      #    }.to raise_error(DotenvHaiku::App::NoAppEnvFound)
      #  end
      #  it "should raise an error with only an :app_env argument" do
      #    expect(DotenvHaiku::Loader).to receive(:new).never
      #
      #    expect {
      #      DotenvHaiku::App.load(:app_env => app_env_arg)
      #    }.to raise_error(DotenvHaiku::App::NoAppRootFound)
      #  end
      #  it "should use :app_env & :app_root arguments" do
      #    expect(DotenvHaiku::Loader).to receive(:new)\
      #      .with(
      #        hash_including(
      #          :app_env => a_string_inquirer(app_env_arg),
      #          :app_root => app_root_arg
      #        )
      #      )
      #
      #    DotenvHaiku::App.load(
      #      :app_env => app_env_arg,
      #      :app_root => app_root_arg
      #    )
      #  end
      #end

      context "with Rails.env only" do
        before(:context) do
          #class ::Rails
          #  def self.env; "via_rails_env"; end
          #  def self.root; nil; end
          #end
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
        #class ::Rails
        #  def self.root; "via_rails_root"; end
        #end

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

      context "with RAILS_ENV and RAILS_ROOT" do
        before :context do
          #class ::Rails
          #  def self.env; "via_rails_env"; end
          #  def self.root; "via_rails_root"; end
          #end
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
