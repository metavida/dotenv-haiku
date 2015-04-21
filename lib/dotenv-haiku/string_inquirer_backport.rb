class DotenvHaiku # rubocop:disable Style/Documentation
  if RUBY_VERSION < "1.9"
    # Backport ActiveSupprt::StringInquirer from Rails 3.2.21
    # See https://github.com/rails/rails/blob/v3.2.21/activesupport/lib/active_support/string_inquirer.rb
    class StringInquirerBackport < String
      def method_missing(method_name, *arguments)
        if method_name.to_s[-1, 1] == "?"
          self == method_name.to_s[0..-2]
        else
          super
        end
      end
    end
  else
    # Backport ActiveSupprt::StringInquirer from Rails 4.2.1
    # See https://github.com/rails/rails/blob/v4.2.1/activesupport/lib/active_support/string_inquirer.rb
    class StringInquirerBackport < String
      private

      def respond_to_missing?(method_name, _include_private = false)
        method_name[-1] == "?"
      end

      def method_missing(method_name, *arguments)
        if method_name[-1] == "?"
          self == method_name[0..-2]
        else
          super
        end
      end
    end
  end
end
