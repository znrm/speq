# The Unit class is responsible for running a test and storing the result
module Speq
  class Unit
    def initialize(message, receiver, arguments, matcher)
      @result = matcher.match(receiver.send(message, *arguments))
    rescue StandardError => exception
      @result = matcher.match(exception)
    end

    def passed?
      @result
    end
  end
end
