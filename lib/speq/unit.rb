module Speq
  # The Unit class is responsible for running a test and storing the result
  class Unit
    attr_reader :result, :action, :matcher
    # A unit is initialized with an action and matcher.
    # @param action [Action]
    # @param matcher [Matcher]
    def initialize(action, matcher)
      @action = action
      @matcher = matcher
      @has_run = false
    end
    
    def passed?
      run unless @has_run
      @result
    end

    def run
      @result = matcher.match?(action)
    rescue StandardError => exception
      @result = matcher.match?(exception)
    ensure
      @has_run = true
    end

    def to_s
      "    #{action} #{matcher}."
    end

    def inspect
      { action: @action, result: @result, matcher: matcher.to_s }
    end
  end
end
