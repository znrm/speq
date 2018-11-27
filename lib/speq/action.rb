require 'speq/matcher'
require 'speq/unit'

module Speq
  class Action
    attr_accessor :test_group, :message_queue, :receiver, :arguments_queue

    def self.clone(action)
      Action.new(
        action.test_group.clone,
        action.message_queue.clone,
        action.receiver,
        action.arguments_queue.clone
      )
    end

    def initialize(test_group, messages = [:itself], receiver = Object, arguments = [{}])
      @test_group = test_group

      @message_queue = messages
      @arguments_queue = arguments
      @receiver = receiver
    end

    def method_missing(method, *args, &block)
      if method.to_s.end_with?('?')
        matcher = Matcher.send(method, *args, &block)
        @test_group << Unit.new(self, matcher)
      else
        super
      end
    end

    def result
      until @message_queue.empty?
        args = arguments_queue.shift
        message = message_queue.shift

        @receiver = receiver.send(message, *args[:args], &args[:block])
      end

      @receiver
    end

    def on(receiver)
      @receiver = receiver
      self
    end

    def does(*messages)
      messages.each do |message|
        message_queue.push(message)
        arguments_queue.push({})
      end

      self
    end

    def with(*args, &block)
      arguments_queue.last[:args] = args
      arguments_queue.last[:block] = block

      self
    end

    alias is does
    alias of with
  end
end
