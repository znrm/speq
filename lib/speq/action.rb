require 'speq'

module Speq
  class Action
    attr_accessor :test_group, :message_queue, :receiver, :arguments_queue

    def initialize(
      test_group,
      receiver = Object,
      messages = [:itself],
      arguments = [{ args: [], block: nil }]
    )
      @test_group = test_group

      @message_queue = messages
      @arguments_queue = arguments
      @receiver = receiver
    end

    def method_missing(method, *args, &block)
      if method.to_s.end_with?('?')
        matcher = Matcher.send(method, *args, &block)
        @test_group << Unit.new(clone, matcher)
      else
        super
      end
    end

    def clone
      self.class.new(
        test_group,
        receiver,
        message_queue.clone,
        arguments_queue.clone
      )
    end

    def result
      until @message_queue.empty?
        args = arguments_queue.shift
        message = message_queue.shift

        @receiver = receiver.send(message, *args[:args], &args[:block])
      end

      @receiver
    end

    def on(receiver, description = nil)
      @receiver = receiver
      Speq.descriptions[receiver] = description || receiver
      self
    end

    def does(*messages)
      messages.each do |message|
        message_queue.push(message)
        arguments_queue.push(args: [], block: nil)
      end

      self
    end

    def with(*args, &block)
      arguments_queue.last[:args] = args
      arguments_queue.last[:block] = block

      self
    end

    def format_arguments
      arguments = arguments_queue.last
      argument_description = ''

      unless arguments[:args].empty?
        argument_description << "with '#{arguments[:args].join(', ')}'"
      end

      argument_description << ' and a block' if arguments[:block]

      argument_description
    end

    def format_receiver
      Speq.descriptions[receiver] ? "on '#{Speq.descriptions[receiver]}'" : ''
    end

    def to_s
      [message_queue.last, format_arguments, format_receiver]
        .reject(&:empty?)
        .join(' ')
    end

    alias is does
    alias of with
  end
end
