require 'speq/action'

# The Unit class is responsible for running a test and storing the result
module Speq
  class Unit
    attr_reader :result, :action, :matcher

    def initialize(action, matcher)
      @action = action
      @matcher = matcher
      @result = matcher.match?(action.clone.result)
    rescue StandardError => exception
      @result = matcher.match?(exception)
    end

    def passed?
      @result
    end

    def to_s
      "    #{action} #{matcher}."
    end

    def inspect
      { action: @action, result: @result, matcher: matcher.to_s }
    end
  end
end
