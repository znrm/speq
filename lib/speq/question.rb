# frozen_string_literal: true

require 'speq/values'

module Speq
  # Error class for Question
  class QuestionError < StandardError
    def initialize(question_name, error)
      super("#{question_name}: #{error}")
    end
  end

  # Records the question name, result, and constructs the corresponding matcher
  class Question
    def self.question?(method_name)
      method_name.to_s.end_with?('?')
    end

    attr_reader :question_name, :matcher, :result

    def initialize(question_name, result, matcher)
      @question_name = question_name
      @result = result
      @matcher = matcher
    end

    def phrase
      matcher.phrase(result)
    rescue StandardError => e
      QuestionError.new(@question_name, e.inspect).to_s
    end

    def outcome
      matcher.match?(result) ? Outcome.pass : Outcome.fail
    rescue StandardError
      Outcome.error
    end

    def self.for(result, question_name, *args, &block)
      matcher = Matcher.for(question_name, *args, &block)

      Question.new(
        question_name,
        result,
        matcher
      )
    end
  end

  # Boolean #match? for a given result and descriptive phrase
  class Matcher
    def initialize(matcher, pass_phrase, fail_phrase)
      @matcher = matcher
      @pass_phrase = pass_phrase
      @fail_phrase = fail_phrase
    end

    def match?(actual)
      @matcher[actual]
    end

    def phrase(actual)
      @matcher[actual] ? @pass_phrase : @fail_phrase
    end

    def self.matcher_is(match, thing)
      new(match, "is #{thing}", "is not #{thing}")
    end

    def self.for(question_name, *args, &block)
      if respond_to?(question_name)
        send(question_name, *args, &block)
      else
        result_matcher(question_name, *args, &block)
      end
    end

    def self.match?(description, &block)
      new(block, "matches #{description}", "does not match #{description}")
    end

    def self.result_matcher(question_name, *args, &block)
      new(
        lambda do |obj|
          if obj.respond_to?(question_name)
            return obj.send(question_name, *args, &block)
          end

          raise "No question called #{question_name.inspect} or existing method on #{obj.inspect}"
        end,
        "is #{question_name[0..-2]}",
        "is not #{question_name[0..-2]}"
      )
    end

    def self.eq?(expected_value)
      new(
        ->(result) { expected_value == result },
        "equals #{expected_value.inspect}",
        "does not equal #{expected_value.inspect}"
      )
    end

    def self.true?
      matcher_is(->(result) { result == true }, 'true')
    end

    def self.truthy?
      matcher_is(->(actual_value) { actual_value ? true : false }, 'truthy')
    end

    def self.falsy?
      matcher_is(->(actual_value) { actual_value ? false : true }, 'falsey')
    end

    def self.a?(type)
      matcher_is(->(val) { val.is_a?(type) }, "a #{type}")
    end

    def self.have?(*symbols, **key_value_pairs)
      new(
        lambda do |object|
          symbols.each do |symbol|
            return false unless object.respond_to?(symbol)
          end
          key_value_pairs.each do |key, value|
            return false unless object.send(key) == value
          end
        end,
        "has #{symbols.empty? ? nil : symbols}#{key_value_pairs}",
        "doesn't have #{symbols.empty? ? nil : symbols}#{key_value_pairs}"
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
        ->(actual_except) { actual_except.class <= expected_error },
        "raises #{expected_error}",
        "does not raise #{expected_error}"
      )
    end

    def self.raise_message(expected_message)
      Matcher.new(
        ->(actual_except) { actual_except.message == expected_message },
        "raises #{expected_message.inspect}",
        "does not raise #{expected_message.inspect}"
      )
    end
  end
end
