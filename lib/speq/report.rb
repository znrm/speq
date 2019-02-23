module Speq
  # The Report class produces and prints a report per test group
  class Report
    def initialize(tests)
      @units = tests.flat_map(&:units)
      @passed = []
      @failed = []
    end

    def print_report
      @units.each do |unit|
        if unit.passed?
          @passed << unit.to_s.colorize(:green)
        else
          @failed << unit.to_s.colorize(:red)
        end
      end

      puts "Passed (#{@passed.length}/#{@units.length})" unless @passed.empty?
      puts @passed
      puts "Failed (#{@failed.length}/#{@units.length})" unless @failed.empty?
    end
  end
end
