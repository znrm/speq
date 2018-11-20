require 'speq/action'

# A
module Speq
  class Test
    def initialize
      @actions = []
      @matchers = []
    end

    def passed?
      @matchers.all?(&:passed?)
    end

    def new_matcher(matcher)
      @matchers << matcher
      @matchers.last
    end

    def <<(action)
      @actions << action
      self
    end
  end
end
