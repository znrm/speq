require 'speq/action'

# The Unit class is responsible for running a test and storing the result
module Speq
  class Unit
    attr_reader :result, :action, :matcher

    def initialize(action, matcher)
      @action = action
      @matcher = matcher
      @result = matcher.match?(action_result)
    rescue StandardError => exception
      @result = matcher.match?(exception)
    end

    def passed?
      @result
    end

    def phrase
      "#{matcher.match_phrase} #{action_result}"
    end

    def action_result
      Action.clone(action).result
    end

    def message
      action.message_queue.last
    end

    def arguments
      action.arguments_queue.last
    end

    def receiver
      action.receiver
    end
  end
end
