require 'speq/match'

# The Test class is a simple implementation of unit test block
module Speq
  class Test
    attr_reader :method, :reciever, :report

    def initialize(method_symbol, class_name = Object, &block)
      @method = method_symbol
      @reciever = class_name
      @units = []

      instance_eval(&block)
      print_report
    end

    def given(*args, match:)
      args.each do |arg|
        return_value = reciever.send(method, *arg)

        @units << Match.new(return_value, :eql?, arg, match)
      end
    end

    def on(*receivers, match:)
      receivers.each do |receiver|
        return_value = receiver.send(method)

        @units << Match.new(return_value, :eql?, arg, match)
      end
    end

    def passed?
      @units.all?(&:passed?)
    end

    def print_report
      report_string = "Testing: #{method}\n"

      @units.each do |one_test|
        if one_test.passed?
          outcome_text = 'PASSED'
          color = :green
        else
          outcome_text = 'FAILED'
          color = :red
        end

        indent = ' ' * @method.to_s.length

        report_string <<
          ["\n#{outcome_text} when given: #{one_test.args}\n".colorize(color),
           "        returned: #{one_test.actual}\n".colorize(color),
           "        expected: #{one_test.expected}\n".colorize(color)].join
      end
      puts report_string

      passed?
    end
  end
end
