require "spec_helper"

# Dummy Rails class
class Rails
end

describe DotenvHaiku do
  #before do
  #  Dir.chdir(File.expand_path("../fixtures", __FILE__))
  #end

  describe ".app_name" do
    it "defaults to 'Rails'" do
      expect(DotenvHaiku.send(:app_name)).
        to eq('Rails')
    end

    it "can be overridden" do
      expected = 'Sinatra'
      allow(DotenvHaiku).to receive(:options) { {:app_name => expected} }

      expect(DotenvHaiku.send(:app_name)).
        to eq(expected)
    end
  end

  describe ".app_version" do
    it "defaults to Rails.env" do
      expected = '4.32.99'
      expect(Rails).to receive(:version) { expected }

      expect(DotenvHaiku.send(:app_version)).
        to equal(expected)
    end

    it "can be overridden" do
      expected = '4.32.98'
      expect(DotenvHaiku).to receive(:options).
        at_least(:once) { {:app_version => expected} }

      expect(Rails).to receive(:version).never

      expect(DotenvHaiku.send(:app_version)).
        to equal(expected)
    end
  end
end