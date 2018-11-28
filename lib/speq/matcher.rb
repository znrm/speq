# The Match class includes factory methods for generating objects that
# respond to match, returning true for an expected return value of a unit test
module Speq
  class Matcher
    def initialize(expectation, phrase)
      @expectation = expectation
      @phrase = phrase
    end

    def match?(actual)
      @actual = actual
      @expectation[actual]
    end

    def to_s
      @phrase[@actual]
    end

    def self.pass?(&prc)
      Matcher.new(prc)
    end

    def self.true?
      Matcher.eq?(true)
    end

    def self.truthy?
      Matcher.new(->(actual_value) { actual_value ? true : false })
    end

    def self.falsy?
      Matcher.new(->(actual_value) { actual_value ? false : true })
    end

    def self.eq?(expected_value)
      Matcher.new(
        ->(actual_value) { expected_value.eql?(actual_value) },
        ->(actual_value) { "equals #{actual_value}" }
      )
    end

    def self.have?(*symbols, **key_value_pairs)
      new(
        lambda do |object|
          symbols.each { |symbol| return false unless object.respond_to?(symbol) }
          key_value_pairs.each { |key, value| return false unless object.send(key) == value }
        end,
        proc do
          properties = symbols.empty? ? '' : symbols.join(' ') + ', '
          values = key_value_pairs.map { |key, value| "#{key}: #{value}" }.join(' ')
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
      Matcher.new(->(actual_except) { actual_except.class <= expected_error })
    end

    def self.raise_message(expected_message)
      Matcher.new(
        ->(actual_except) { actual_except.message == expected_message }
      )
    end
  end
end
