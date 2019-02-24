require 'pp'
module Speq
  # The Report class produces and prints a report per test group
  class Report
    def initialize(tests)
      @tests = tests
    end

    def inspect
      @tests.each { |test| pp test }
    end
  end
end

# def initialize(tests)
#   @units = tests.flat_map(&:units)
#   @passed = []
#   @failed = []

#   @units.each do |unit|
#     if unit.passed?
#       @passed << unit.to_s.colorize(:green)
#     else
#       @failed << unit.to_s.colorize(:red)
#     end
#   end
# end

# def print_report()
#   puts "Passed (#{@passed.length}/#{@units.length})" unless @passed.empty?
#   puts @passed
#   puts "Failed (#{@failed.length}/#{@units.length})" unless @failed.empty?
# end
# end

# attr_reader :units, :receiver, :messages

# def initialize(units, receiver = Object, messages = [])
#   @units = units
#   @receiver = receiver
#   @messages = messages
# end

# def result
#   messages.reduce(@receiver) do |receiver, message|
#     message.send_to(receiver)
#   end
# end

# def format_receiver
#   return '' unless Speq.descriptions[receiver]

#   (messages.last&.has_method? ? 'on ' : '') + Speq.descriptions[receiver]
# end

# def to_s
#   [messages.last.to_s, format_receiver].reject(&:empty?).join(' ')
# end

# def inspect
#   { receiver: receiver, messages: messages }
# end
