require 'speq/unit'
require 'speq/fake'
require 'speq/action'
require 'speq/matcher'

module Speq
  class Test
    attr_reader :units

    def initialize(units = [], context = {}, &block)
      @units = units
      @context = context
      instance_exec(&block) if block_given?
    end

    def passed?
      @units.all?(&:passed?)
    end

    def score; end

    def method_missing(method_name, *args, &block)
      if matcher_method?(method_name)
        puts 'detected matcher method'
      # matcher = Matcher.send(method_name, *args, &block)
      # @units << Unit.new(self, matcher)
      # self
      elsif Speq.respond_to?(method_name)
        puts Speq.send(method_name, *args, &block)
      else
        super
      end
    end

    def is
      puts 'is'
      self
    end

    def on
      self << Message.new
      puts 'on'
      self
    end

    # def on(receiver, description = nil, &block)
    #   @receiver = receiver
    #   Speq.descriptions[receiver] = description || "'#{receiver}'"
    #   instance_exec(&block) if block
    #   self
    # end

    def does
      self << Action.new
      puts 'does'
      self
    end

    # def does(*methods)
    #   methods.each do |method|
    #     if messages.empty?
    #       messages << Message.new(method: method)
    #       self
    #     elsif messages.last.has_method?
    #       new_self = clone
    #       new_self.does(*methods)
    #       new_self
    #     else
    #       messages.last << method
    #       self
    #     end
    #   end
    # end

    def with
      puts 'with'
      self
    end

    alias of with

    # def with(*args, &block)
    #   if messages.last.has_args?
    #     messages << Message.new(args: args, block: block)
    #   else
    #     messages.last << args
    #     messages.last << block
    #   end

    #   self
    # end

    def matcher_method?(method_name)
      method_name.to_s.end_with?('?')
    end

    def <<(unit)
      @units << unit
      self
    end

    def hello
      puts 'should be private'
    end
  end
end

# def report
#   Report.new(@tests).print_report
# end

# def inspect
#   "Test: #{{ units: @units }}"
# end

# def then(*methods)
#   does(*methods)
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

# def is(method_or_receiver, description = nil)
#   if Symbol === method_or_receiver && !description
#     does(method_or_receiver)
#   else
#     on(method_or_receiver, description)
#   end

#   self
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
