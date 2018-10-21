# The Report class produces and prints a report per test group
module Speq
  class Report
    def initialize(units)
      @units = units
    end

    def print_report
      report_string = ''

      @units.each do |unit|
        if unit.passed?
          outcome = 'PASSED: '
          color = :green
        else
          outcome = 'FAILED: '
          color = :red
        end

        method = "calling '#{unit.message}' "
        arguments = unit.arguments ? "with arguments: '#{unit.arguments}'" : ''
        receiver = unit.receiver == Object ? '' : "on: #{unit.receiver} "

        report_string <<
          [outcome, method, arguments, receiver, "\n"].join.colorize(color)
      end

      puts report_string
    end
  end
end
