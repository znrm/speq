module Speq
  # The Unit class is responsible for running a test and storing the result
  class Unit
    attr_reader :result, :action, :matcher

    def initialize(action, matcher)
      @action = action
      @matcher = matcher
      run
    end

    def passed?
    end

    def run
      @result = matcher.match?(action.evaluate)
      p @result
    rescue StandardError => exception
      p exception
      @result = matcher.match?(exception)
    ensure
      @has_run = true
    end

    def to_s
      "    #{action.to_s} #{matcher.to_s}."
    end

    def inspect
      { action: @action, matcher: matcher, result: @result }
    end
  end
end
