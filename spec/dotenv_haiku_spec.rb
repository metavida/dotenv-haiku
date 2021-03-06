require "spec_helper"

# Dummy class
class Rails
end

describe DotenvHaiku do
  describe ".load" do
    it "should call set_up_app if no ::App is defined" do
      DotenvHaiku.send(:remove_const, :App) if defined? DotenvHaiku::App

      expect(DotenvHaiku).to receive(:set_up_app) do
        # dummy set_up_app
        class DotenvHaiku::App
          def self.load; end
        end
      end

      DotenvHaiku.load
    end

    it "should not call set_up_app if ::App is already defined" do
      # dummy set_up_app
      class DotenvHaiku::App
        def self.load; end
      end

      expect(DotenvHaiku).to receive(:set_up_app).never

      DotenvHaiku.load
    end
  end

  describe ".require_rails_app" do
    it "should rails1 when appropriate" do
      expect(DotenvHaiku).to receive(:app_version) { "1.2.6" }
      expect(DotenvHaiku).to receive(:require).with(match(%r{/to_load/rails1$}))

      DotenvHaiku.send(:require_rails_app)
    end

    it "should fails for rails2" do
      expect(DotenvHaiku).to receive(:app_version) { "2.0.0" }
      expect(DotenvHaiku).to receive(:require).never

      expect {
        DotenvHaiku.send(:require_rails_app)
      }.to raise_error(RuntimeError)
    end

    it "should rails3 when appropriate" do
      expect(DotenvHaiku).to receive(:app_version) { "3.0.0" }
      expect(DotenvHaiku).to receive(:require).with(match(%r{/to_load/rails3$}))

      DotenvHaiku.send(:require_rails_app)
    end

    it "should rails4 when appropriate" do
      expect(DotenvHaiku).to receive(:app_version) { "4.1.0" }
      expect(DotenvHaiku).to receive(:require).with(match(%r{/to_load/rails4$}))

      DotenvHaiku.send(:require_rails_app)
    end
  end

  describe ".app_name" do
    it "defaults to 'Rails'" do
      expect(DotenvHaiku.send(:app_name))
        .to eq("Rails")
    end

    it "can be overridden" do
      expected = "Sinatra"
      allow(DotenvHaiku).to receive(:options) { { :app_name => expected } }

      expect(DotenvHaiku.send(:app_name))
        .to eq(expected)
    end
  end

  describe ".app_version" do
    it "defaults to Rails.env" do
      expected = "4.32.99"
      expect(Rails).to receive(:version) { expected }

      expect(DotenvHaiku.send(:app_version))
        .to equal(expected)
    end

    it "can be overridden" do
      expected = "4.32.98"
      expect(DotenvHaiku).to receive(:options)
        .at_least(:once) { { :app_version => expected } }

      expect(Rails).to receive(:version).never

      expect(DotenvHaiku.send(:app_version))
        .to equal(expected)
    end
  end
end
