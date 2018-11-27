# The Report class produces and prints a report per test group
module Speq
  class Report
    def initialize(tests)
      @units = tests.flat_map(&:units)
      @passed = []
      @failed = []
    end

    def format_arguments(arguments)
      argument_description = ''

      unless arguments[:args].empty?
        argument_description << "with '#{arguments[:args].join(', ')}'"
      end
      argument_description << ' and a block' if arguments[:block]
      argument_description
    end

    def format_receiver(receiver)
      receiver == Object ? '' : "on #{receiver} "
    end

    def unit_report(unit)
      ['   ',
       unit.message,
       format_arguments(unit.arguments),
       format_receiver(unit.receiver),
       unit.phrase].join(' ')
    end

    def print_report
      @units.each do |unit|
        report = unit_report(unit)

        if unit.passed?
          @passed << report.colorize(:green)
        else
          @failed << report.colorize(:red)
        end
      end

      puts "Passed (#{@passed.length}/#{@units.length})" unless @passed.empty?
      puts @passed
      puts "Failed (#{@failed.length}/#{@units.length})" unless @failed.empty?
    end
  end
end
