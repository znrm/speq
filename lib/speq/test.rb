module Speq
  # Test is initialized with units.
  # Units must implement #passed?
  class Test
    attr_reader :units

    # @param units [Array[Unit|Test]]
    def initialize(units = [])
      @units = units
    end

    def passed?
      @units.all?(&:passed?)
    end

    def <<(unit)
      @units << unit
      self
    end

    def inspect
      @units.map(&:inspect)
    end
  end
end
