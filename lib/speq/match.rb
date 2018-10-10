# The Match class includes a variety of matchers
module Speq
  class Match
    attr_reader :actual, :expected, :passed, :args

    def initialize(actual, match_sym, args, expected = nil)
      @actual = actual
      @expected = expected
      @passed = false
      @args = args

      evaluate_match(match_sym)
    end

    def evaluate_match(match_sym)
      case match_sym
      when :eql?, :equal?
        @passed = actual.send(match_sym, expected)
      end
    end

    def passed?
      @passed
    end
  end
end
