module Speq
  # The Matcher class includes factory methods for generating objects that
  # respond to #match?
  class Matcher
    def initialize(name, expectation, phrase)
      @name = name
      @expectation = expectation
      @phrase = phrase
    end

    def match?(actual)
      @expectation[actual]
    end

    def self.matcher_method?(method_name)
      method_name.to_s.end_with?("?")
    end

    def self.for(method_name, *args, &block)
      Matcher.new(
        method_name,
        ->(object) { object.send(method_name, *args, &block) },
        proc { "is #{method_name[0..-2]}" }
      )
    end

    def self.pass?(&prc)
      Matcher.new(:pass?, prc, proc { "passes" })
    end

    def self.true?
      Matcher.eq?(true)
    end

    def self.truthy?
      Matcher.new(->(actual_value) { actual_value ? true : false })
    end

    def self.falsy?
      Matcher.new(:falsey?, ->(actual_value) { actual_value ? false : true })
    end

    def self.eq?(expected_value)
      Matcher.new(
        :eq?,
        ->(actual_value) { expected_value.eql?(actual_value) },
        ->() { "equals #{expected_value}" }
      )
    end

    def self.have?(*symbols, **key_value_pairs)
      new(
        ->(object) {
          symbols.each { |symbol| return false unless object.respond_to?(symbol) }
          key_value_pairs.each { |key, value| return false unless object.send(key) == value }
        },
        proc do
          properties = symbols.empty? ? "" : symbols.join(" ") + ", "
          values = key_value_pairs.map { |key, value| "#{key}: #{value}" }.join(" ")
          "has #{properties}#{values}"
        end
      )
    end

    def self.raise?(expected_except)
      case expected_except
      when Class
        raise_class(expected_except)
      when String
        raise_message(expected_except)
      else
        raise ArgumentError
      end
    end

    def self.raise_class(expected_error)
      Matcher.new(
        :raise_class,
        ->(actual_except) { actual_except.class <= expected_error },
        ->(actual_except) { "raises #{actual_except}" }
      )
    end

    def self.raise_message(expected_message)
      Matcher.new(
        :raise_message,
        ->(actual_except) { actual_except.message == expected_message },
        ->(actual_except) { "raises #{actual_except}" }
      )
    end

    def inspect
      "Match: #{@name}"
    end

    def to_s
      @phrase[]
    end
  end
end
