require 'speq/fake'
require 'speq/matcher'

module Speq
  # Core class that handles building up tests
  class Test
    attr_reader :units

    def self.parse(&block)
      Test.new(&block).units
    end

    def initialize(units = [], &block)
      @units = units
      instance_exec(&block) if block_given?
    end

    def passed?
      @units.all?(&:passed?)
    end

    def score; end

    def report
      Report.new([self])
    end

    private

    def run
      @units.each(&:run)
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
      record(:does, methods)
      test(&block) if block_given?
      self
    end

    def with(*args, &block)
      record(:with, args, block)
    end

    def test(&block)
      record(:test, Test.parse(&block))
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

    def record(key, *values)
      @units << key << values
      self
    end
  end
end