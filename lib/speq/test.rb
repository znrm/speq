require 'speq/action'

# A
module Speq
  class Test
    attr_reader :units

    def initialize
      @units = []
    end

    def passed?
      @units.all?(&:passed?)
    end

    def <<(unit)
      @units << unit
      self
    end
  end
end
