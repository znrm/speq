require 'speq'
require 'speq/message'

module Speq
  class Action
    attr_reader :test_group, :receiver, :messages

    def initialize(test_group, receiver = Object, messages = [])
      @test_group = test_group
      @receiver = receiver
      @messages = messages
    end

    def method_missing(method_name, *args, &block)
      if Speq.matcher_method?(method_name)
        matcher = Matcher.send(method_name, *args, &block)
        @test_group << Unit.new(clone, matcher)
        self
      else
        super
      end
    end

    def clone
      Action.new(test_group, receiver, messages.clone)
    end

    def result
      messages.reduce(@receiver) do |receiver, message|
        message.send_to(receiver)
      end
    end

    def on(receiver, description = nil)
      @receiver = receiver
      Speq.descriptions[receiver] = description || "'#{receiver}'"
      self
    end

    def does(*methods)
      methods.each do |method|
        if messages.empty? || messages.last.has_method?
          messages << Message.new(method: method)
        else
          messages.last << method
        end
      end

      self
    end

    def is(method_or_receiver, description = nil)
      if Symbol === method_or_receiver && !description
        does(method_or_receiver)
      else
        on(method_or_receiver, description)
      end

      self
    end

    def with(*args, &block)
      if messages.last.has_args?
        messages << Message.new(args: args, block: block)
      else
        messages.last << args
        messages.last << block
      end

      self
    end

    def then(*methods)
      does(*methods)
    end

    def format_receiver
      return '' unless Speq.descriptions[receiver]

      (messages.last&.has_method? ? 'on ' : '') + Speq.descriptions[receiver]
    end

    def to_s
      [messages.last.to_s, format_receiver].reject(&:empty?).join(' ')
    end

    def inspect
      { receiver: receiver, messages: messages }
    end

    alias of with
  end
end
