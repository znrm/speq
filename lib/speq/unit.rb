# The Unit class is responsible for running a test and storing the result
module Speq
  class Unit
    attr_reader :message, :receiver, :arguments

    def initialize(message = :itself, receiver = Object, arguments = [], matcher)
      @result = matcher.match(receiver.send(message, *arguments))
    rescue StandardError => exception
      @result = matcher.match(exception)
    ensure
      @message = message
      @receiver = receiver
      @arguments = arguments
    end

    def passed?
      @result
    end
  end
end
