require 'speq/action'

# The Test class is a simple implementation of unit test block
module Speq
  class Test
    def initialize
      @units = []
    end

    def passed?
      @units.all?(&:passed?)
    end
  end
end
