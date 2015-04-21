require "spec_helper"
require "dotenv-haiku/string_inquirer_backport"

# Dummy class
class Rails
end

describe DotenvHaiku::Loader do
  before do
    @app_root = fixture_path("")
  end

  describe ".to_a" do
    context "development environment" do
      before do
        @loader = DotenvHaiku::Loader.new(
          :app_env  => DotenvHaiku::StringInquirerBackport.new("development"),
          :app_root => @app_root
        )
      end

      it "should include .env files in the correct order" do
        expect(@loader.to_a)
          .to eq(%w(
            .env.custom
            .env.local
            .env.development
            .env
          ).map { |file| fixture_path(file) })
      end
    end

    context "test environment" do
      before do
        @loader = DotenvHaiku::Loader.new(
          :app_env  => DotenvHaiku::StringInquirerBackport.new("test"),
          :app_root => @app_root
        )
      end

      it "should include .env files in the correct order" do
        expect(@loader.to_a)
          .to eq(%w(
            .env.local
            .env.test
            .env
          ).map { |file| fixture_path(file) })
      end
    end

    context "production environment" do
      before do
        @loader = DotenvHaiku::Loader.new(
          :app_env  => DotenvHaiku::StringInquirerBackport.new("production"),
          :app_root => @app_root
        )
      end

      it "should include .env files in the correct order" do
        File.open(fixture_path(".env.production"), "w") do |file|
          file.puts("PROD=true")
        end

        expect(@loader.to_a)
          .to eq(%w(
            .env.local
            .env.production
            .env
          ).map { |file| fixture_path(file) })
      end

      it "should fail if .env.production does not exist" do
        FileUtils.rm_f(fixture_path(".env.production"))

        expect { @loader.to_a }
          .to raise_error(DotenvHaiku::Loader::MissingDotenv)

        # /Users/marcoswk/workspace/dotenv-haiku/spec/fixtures/.env.production
        # /Users/marcoswk/workspace/dotenv-haiku/spec/fixtures/.env.production
      end
    end
  end
end
