# frozen_string_literal: true

require 'speq/recruit'
require 'speq/values'
require 'speq/string_fmt'
require 'speq/question'

def speq(description, &block)
  Speq::Test.new(description, &block)
end

# Build simple tests with fewer words
module Speq
  # Test code executes within the context of this class
  class TestBlock
    METHODS = %i[speq on does with of is].freeze

    def initialize(parent, &block)
      @outer_scope = eval('self', block.binding)
      @parent = parent
      instance_eval(&block)
    end

    def speq(description, &block)
      @parent.speq(description, &block)
    end

    def method_missing(method_name, *args, &block)
      if METHODS.include?(method_name) ||
         @parent.context && Question.question?(method_name)
        Expression.new(@parent).send(method_name, *args, &block)
      elsif @outer_scope.respond_to?(method_name)
        @outer_scope.send(method_name, *args, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      METHODS.include?(method_name) ||
        @outer_scope.respond_to?(method_name) ||
        super
    end
  end

  # Common interface for all for Test and Expression
  class Group
    attr_reader :units, :context, :parent

    def initialize(parent = nil)
      @parent = parent
      @context = Context.new
      @units = []
    end

    def outcome
      Outcome.aggregate(units.map(&:outcome))
    end

    def pass?
      outcome.pass?
    end

    def fail?
      outcome.fail?
    end

    def error?
      outcome.error?
    end

    def <<(unit)
      units << unit
    end

    def full_context
      parent ? context.merge(parent.full_context) : context
    end
  end

  # A test group is a collection of tests with a description
  class Test < Group
    attr_reader :description

    def initialize(description, parent = nil, &block)
      super(parent)
      @description = description
      run &block if block_given?
    end

    def run(&block)
      TestBlock.new(self, &block)
    end

    def speq(description, &block)
      self << Test.new(description, self, &block)
    end
  end

  # An expression group carries context for evaluation and associated questions
  class Expression < Group
    attr_reader :result

    def initialize(parent)
      super(parent)
      @result = nil
    end

    def result=(val)
      @result = val unless result
    end

    def evaluate_result
      self.result = full_context.evaluate
    end

    def speq(description = "#{context}...", &block)
      parent << Test.new(description, self, &block)
    end

    def on(val, description = nil, &block)
      context.subject = Subject.new(val, description)
      speq &block if block_given?
      self
    end

    def does(val, description = nil, &block)
      context.message = Message.new(val, description)
      speq &block if block_given?
      self
    end

    def with(*args, &block)
      context.arguments = Arguments.new(*args, &block)
      self
    end

    alias of with

    def is(thing, description = nil, &block)
      if thing.is_a?(Symbol)
        does(thing, description, &block)
      else
        on(thing, description, &block)
      end
    end

    def method_missing(method_name, *args, &block)
      if Question.question?(method_name)
        if result.nil?
          parent << self
          evaluate_result
        end
        self << Question.for(result.value, method_name, *args, &block)
        self
      else
        super
      end
    end

    def respond_to_missing?(method_name, *)
      Question.question?(method_name) || super
    end
  end
end
