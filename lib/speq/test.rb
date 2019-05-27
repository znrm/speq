require "speq/fake"
require "speq/matcher"

module Speq
  # Core class that handles building up tests
  class Test
    attr_reader :units, :context, :current_unit

    def initialize(context = {}, &block)
      @context = context
      @units = []
      @names = {}

      new_unit
      parse_units(&block) if block_given?
    end

    def parse_units(&block)
      instance_exec(&block) if block_given?
      current_unit.merge!(@context)
    end

    def report
      @report ||= Report.new([self])
    end

    def score
      report.score
    end

    def respond_to_missing?(method_name, include_private = false)
      Matcher.matcher_method?(method_name) ||
        Speq.respond_to?(method_name) ||
        super
    end

    def method_missing(method_name, *args, &block)
      if Matcher.matcher_method?(method_name)
        record(:match, method_name, *args, &block)
      elsif Speq.respond_to?(method_name)
        Speq.send(method_name, *args, &block)
      else
        super
      end
    end

    def call(obj, name)
      @names[obj] = name
    end

    def speq(description, &block)
      units << { description: description }
      test(&block) if block_given?
    end

    def on(receiver, description = nil, &block)
      call(receiver, description) if description

      record(:on, receiver)
      test(&block) if block_given?
      self
    end

    def does(*methods, &block)
      record(:does, *methods)
      test(&block) if block_given?
      self
    end

    def with(*args, &block)
      record :with, args: args, block: block
    end

    def test(&block)
      context = units.pop
      units.push(*Test.new(context, &block).units)
    end

    def is(method_or_receiver, description = nil)
      if method_or_receiver.is_a?(Symbol)
        does(method_or_receiver)
      else
        on(method_or_receiver, description)
      end
    end

    def then(*methods, &block)
      on = current_unit
      new_unit({ does: methods })
      current_unit[:on_result_of] = on
      test(&block) if block_given?
      self
    end

    alias of with

    def record(command, *args)
      case command
      when :on, :does, :with
        new_unit if current_unit[command] || current_unit[:match] || context[command]
        current_unit[command] = args
      when :match
        units << current_unit.clone if current_unit[:match] || context[:match]
        current_unit[:match] = args
      end
      self
    end

    def current_unit
      @units.last
    end

    def new_unit(fields = {})
      @units << {}.merge(@context).merge(fields)
    end
  end
end
