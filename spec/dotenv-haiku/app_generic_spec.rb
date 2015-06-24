require "spec_helper"

context "generic application" do
  before :context do
    undefine DotenvHaiku, :App
    require "dotenv-haiku/to_load/generic"
  end

  describe "DotenvHaiku::App" do
    describe ".load" do
      def app_env_arg
        "app_env_arg"
      end

      def app_root_arg
        "app_root_arg"
      end

      context "with empty ENV" do
        around(:example) do |example|
          override_env(
            {
              "RACK_ENV" => nil,
              "RAILS_ENV" => nil,
              "APP_ENV" => nil
            }, &example)
        end

        it "should raise an error with no arguments" do
          expect(DotenvHaiku::Loader).to receive(:new).never

          expect { DotenvHaiku::App.load }.to raise_error
        end
        it "should use :app_env argument" do
          expect(DotenvHaiku::Loader).to receive(:new)\
            .with(
              hash_including(
                :app_env => a_string_inquirer(app_env_arg),
                :app_root => Dir.pwd
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

      # Test a few different ENV settings
      [
        [
          "with ENV['RACK_ENV']",
          { "RACK_ENV" => "rack_via_env" },
          "rack_via_env"
        ],
        [
          "with ENV['RAILS_ENV']",
          { "RAILS_ENV" => "rails_via_env" },
          "rails_via_env"
        ],
        [
          "with ENV['APP_ENV']",
          { "APP_ENV" => "app_via_env" },
          "app_via_env"
        ],
        [
          "with ENV['RACK_ENV'] and ENV['RAILS_ENV']",
          { "RACK_ENV" => "rack_via_env", "RAILS_ENV" => "rails_via_env" },
          "rack_via_env"
        ],
        [
          "with ENV['RAILS_ENV'] and ENV['APP_ENV]",
          { "APP_ENV" => "app_via_env", "RAILS_ENV" => "rails_via_env" },
          "rails_via_env"
        ]
      ].each do |context_name, given_env, expected_app_env|
        context context_name do
          around(:example) do |example|
            given_env = {
              "RACK_ENV" => nil,
              "RAILS_ENV" => nil,
              "APP_ENV" => nil
            }.merge(given_env)

            override_env(given_env, &example)
          end
          it "should work with no arguments" do
            expect(DotenvHaiku::Loader).to receive(:new)\
              .with(
                hash_including(
                  :app_env => a_string_inquirer(expected_app_env),
                  :app_root => Dir.pwd
                )
              )

            DotenvHaiku::App.load
          end
          it "should use :app_env argument" do
            expect(DotenvHaiku::Loader).to receive(:new)\
              .with(
                hash_including(
                  :app_env => a_string_inquirer(app_env_arg),
                  :app_root => Dir.pwd
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
      end
    end
  end
end
