require 'speq/fake'
require 'speq/matcher'

module Speq
  # Core class that handles building up tests
  class Test
    attr_reader :units, :context

    def self.parse(context = {}, &block)
      Test.new(context, &block).units
    end

    def initialize(context = {}, &block)
      @units = [{}]
      @names = {}
      @context = context
      instance_exec(&block) if block_given?
    end

    def passed?
      @commands.all?(&:passed?)
    end

    def report
      @report ||= Report.new([self])
    end

    def score
      report.score
    end

  protected

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
      record(:name, obj, name)
    end

    def speq(description = nil, &block)
      record(:speq, description, block)
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
      record(:test, *Test.parse(current_unit, &block))
    end

    def is(method_or_receiver, description = nil)
      if method_or_receiver.is_a?(Symbol)
        does(method_or_receiver)
      else
        on(method_or_receiver, description)
      end
    end

    alias of with
    alias then does

    def record(command, *args)
      case command
      when :name
        obj, name = args
        @names[obj] = name
      when :on, :does, :with
        new_unit if current_unit[command] || current_unit[:match] || context[command]
        current_unit[command] = args
      when :match
        units << current_unit.clone if context[:match]
        current_unit[:match] = args
      when :test
        units.pop
        args.each { |nested_unit| units << nested_unit }
      when :speq
        units << { speq: args } << {}
      end

      self
    end

    def current_unit
      @units.last
    end

    def new_unit
      @units << {}.merge(@context)
    end
  end
end
