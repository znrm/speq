# frozen_string_literal: true

require 'colorize'

module Speq
  class TestBlock
    def inspect
      "block in '#{@parent.description}'"
    end
  end

  class Group
    def report
      outcome.report
    end

    def indent
      parent ? parent.indent + '  ' : ''
    end

    def newline
      "\n#{indent}"
    end
  end

  class Test < Group
    def title
      "#{outcome} #{description}"
    end

    def to_s
      [newline, title, units.join('')].join('')
    end
  end

  class Expression < Group
    def indent
      parent.indent
    end

    def to_s
      "#{newline}  #{outcome} #{context} #{units.join('; ')}."
    end
  end

  class Question
    def to_s
      "#{phrase}#{outcome.fail? ? " (result = #{result.inspect})" : ''}"
        .send(outcome.pass? ? :green : :red)
    end
  end

  class Outcome
    def report
      "pass: #{pass_count}, fail: #{fail_count}, errors: #{error_count}"
    end

    def to_s
      pass? ? '✔'.green : 'x'.red
    end
  end

  class Arguments
    def to_s
      p block
      arg_str = args.map(&:inspect).join(', ')
      sep = args.empty? && block ? '' : ', '
      block_str = block ? "#{sep}&{ ... }" : ''
      "#{arg_str}#{block_str}"
    end
  end

  class SomeValue
    def to_s
      description || value.inspect
    end
  end

  class Message < SomeValue
    def to_s
      extra = description ? " (#{description})" : nil
      "#{value}#{extra}"
    end
  end

  class Context
    def to_s
      [arguments && !message ? "with #{arguments}" : nil,
       arguments && message ? "#{message}(#{arguments})" : message,
       message && subject ? 'on' : nil,
       subject].reject(&:nil?).join(' ')
    end
  end
end
