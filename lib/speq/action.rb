require 'speq/matcher'

module Speq
  class Action
    attr_accessor :message_queue, :receiver, :arguments_queue

    def initialize(test_group, message = :itself, receiver = Object, arguments = {})
      @test_group = test_group << self

      @message_queue = [message]
      @arguments_queue = [arguments]
      @receiver = receiver
    end

    def method_missing(method, *args, &block)
      if method.to_s.end_with?('?')
        @test_group.new_matcher(Matcher.send(method, *args, &block))
      else
        super
      end
    end

    def result
      until @message_queue.empty?
        args = arguments_queue.shift
        message = message_queue.shift

        @reciever = receiver.send(message, *args[:args], &args[:block])
      end

      @reciever
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
