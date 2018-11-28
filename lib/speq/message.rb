module Speq
  class Message
    def initialize(method: :itself, args: [], block: nil)
      @method = method
      @args = args
      @block = block
    end

    def send_to(object = Object)
      object.send(@method, *@args, &@block)
    end

    def has_method?
      @method != :itself
    end

    def has_args?
      !@args.empty? || @block
    end

    def <<(object)
      case object
      when Symbol
        @method = object
      when Array
        @args = object
      when Proc
        @block = object
      end

      self
    end

    def to_s
      message_string = ''
      message_string += @method.to_s if has_method?
      message_string += " with '#{@args.join(', ')}'" unless @args.empty?
      message_string += ' and a block' if @block
      message_string
  end
  end
end
