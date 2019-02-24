require 'speq/unit'
require 'speq/fake'
require 'speq/action'
require 'speq/matcher'

module Speq
  class Test
    attr_reader :units

    def initialize(context = {}, &block)
      @units = []
      @context = context
      puts block_given?
      instance_exec(&block) if block_given?
    end

    def passed?
      @units.all?(&:passed?)
    end

    def score; end

    def respond_to_missing?(method_name, include_private = false)
      Matcher.matcher_method?(method_name) || Speq.respond_to?(method_name) || super
    end

    def method_missing(method_name, *args, &block)
      if Matcher.matcher_method?(method_name)
        self << ({ matcher: Matcher.for(method_name, *args, &block) })
      elsif Speq.respond_to?(method_name)
        Speq.send(method_name, *args, &block)
      else
        super
      end
    end

    def is(method_or_receiver, description = nil)
      if Symbol === method_or_receiver && !description
        does(method_or_receiver)
      else
        on(method_or_receiver, description)
      end
    end

    def on(receiver, description = nil, &block)
      @context[receiver] = description || "'#{receiver}'"
      self << ({ on: receiver })
      self << Test.new(@context, &block) if block_given?
      self
    end

    def does(*methods)
      self << ({ does: methods })
    end

    def then(*methods)
      does(*methods)
    end

    def with
      self << ({ with: Message.new(args: args, block: block) })
    end

    alias of with

    def <<(many_things)
      @units << many_things
      self
    end
  end
end

# def report
#   Report.new(@tests).print_report
# end

# def inspect
#   "Test: #{{ units: @units }}"
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
