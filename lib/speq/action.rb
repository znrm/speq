module Speq
  class Action
    attr_accessor :message_queue, :receiver, :arguments_queue

    def initialize(message = :itself, receiver = Object, arguments = {})
      @message_queue = [message]
      @arguments_queue = [arguments]
      @receiver = receiver
    end

    def result
      until @message_queue.empty?
        args = arguments_queue.shift

        @reciever =
          if args[:block]
            receiver.send(next_message, *args[:args], &args[:block])
          else
            receiver.send(next_message, *args[:args])
          end
      end

      @reciever
    end

    def next_message
      message_queue.shift
    end

    def pass?
      yield(result)
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
