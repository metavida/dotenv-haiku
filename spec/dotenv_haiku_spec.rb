require "spec_helper"

# Dummy Rails
module Rails
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

    it "should not call set_up_app if ::App::DETECTED is already defined" do
      # dummy set_up_app
      class DotenvHaiku::App
        DETECTED = 'absolutely'
      end

      expect(DotenvHaiku).to receive(:set_up_app).never

      DotenvHaiku.load
    end
  end

  describe ".require_rails_app" do
    it "should rails1 when appropriate" do
      expect(DotenvHaiku).to receive(:app_version) { "1.2.6" }
      expect(DotenvHaiku).to receive(:require).with(match(%r{/app/rails1$}))

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
      expect(DotenvHaiku).to receive(:require).with(match(%r{/app/rails3$}))

      DotenvHaiku.send(:require_rails_app)
    end

    it "should rails4 when appropriate" do
      expect(DotenvHaiku).to receive(:app_version) { "4.1.0" }
      expect(DotenvHaiku).to receive(:require).with(match(%r{/app/rails4$}))

      DotenvHaiku.send(:require_rails_app)
    end

    context "with Rails 3" do
      before do
        undefine DotenvHaiku, :App
      end
      after do
        undefine DotenvHaiku, :App
      end

      catch :skip_tests do
        skip_unless_rails_between("3.0", "4.0", __FILE__)

        it "should work to load app for rails3" do
          expect {
            DotenvHaiku.send(:require_rails_app)
          }.not_to raise_error
        end
      end
    end

    context "with Rails 4" do
      before do
        undefine DotenvHaiku, :App
      end
      after do
        undefine DotenvHaiku, :App
      end

      catch :skip_tests do
        skip_unless_rails_between("4.0", "5.0", __FILE__)

        it "should work to load app for rails4" do
          expect {
            DotenvHaiku.send(:require_rails_app)
          }.not_to raise_error
        end
      end
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
