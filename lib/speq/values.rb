# frozen_string_literal: true

module Speq
  # Encodes the outcome of a group or individual test
  class Outcome
    def self.error
      Outcome.new([0, 0, 1])
    end

    def self.pass
      Outcome.new([1, 0, 0])
    end

    def self.fail
      Outcome.new([0, 1, 0])
    end

    def self.aggregate(outcomes)
      Outcome.new(
        [outcomes.map(&:pass?).count(true),
         outcomes.map(&:fail?).count(true),
         outcomes.map(&:error?).count(true)]
      )
    end

    attr_accessor :values
    def initialize(values)
      @values = values
    end

    def pass_count
      values[0]
    end

    def fail_count
      values[1]
    end

    def error_count
      values[2]
    end

    def ==(other)
      other.values == values
    end

    def pass?
      fail_count.zero? && error_count.zero?
    end

    def fail?
      !pass? && !error?
    end

    def error?
      error_count.positive?
    end
  end

  # Holds arguments to be passed to something later
  class Arguments
    attr_reader :args, :block
    def initialize(*args, &block)
      @args = args
      @block = block if block_given?
    end
  end

  # Holds any value allowing for a distiction between Some(nil) and None
  class SomeValue
    attr_reader :value
    attr_accessor :description

    def initialize(value, description = nil)
      @value = value
      @description = description
    end
  end

  class Subject < SomeValue; end
  class Message < SomeValue; end

  # Carries expression context for evaluation
  class Context
    attr_accessor :subject, :message, :arguments

    def initialize(subject: nil, message: nil, arguments: nil)
      @subject = subject
      @message = message
      @arguments = arguments
    end

    def merge(context)
      Context.new(**to_h.merge(context.to_h))
    end

    def to_h
      output = {}
      %i[subject message arguments].each do |val|
        output[val] = send(val) if send(val)
      end
      output
    end

    def evaluate
      obj = subject&.value
      msg = message&.value
      args = arguments&.args
      block = arguments&.block

      val = get_value(obj, msg, args, block)

      SomeValue.new(val)
    rescue StandardError => e
      SomeValue.new(e)
    end

    def get_value(obj, msg, args, block)
      if !msg
        obj
      elsif !args
        obj&.public_send(msg) || send(msg)
      elsif !block
        obj&.public_send(msg, *args) || send(msg, *args)
      else
        obj&.public_send(msg, *args, &block) || send(msg, *args, &block)
      end
    end
  end
end
