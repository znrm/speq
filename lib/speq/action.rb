module Speq
  class Action
    def initialize(does: [:itself], on: Object, with: [], **extra)
      @does = does
      @on = on
      @with = with
    end

    def result
      @result || evaluate
    end

    def evaluate
      result = @on
      messages = @does.clone

      until @does.one?
        result = result.send(messages.shift)
      end

      @result = result.send(messages.shift, *@with)
    end

    def inspect
      { does: @does, on: @on, with: @with }
    end

    def to_s
      "Does #{@does} on #{@on} with #{@with}"
    end
  end
end
