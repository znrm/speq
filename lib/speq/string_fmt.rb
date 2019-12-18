# frozen_string_literal: true

require 'colorize'
require 'pp'

module Speq
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
      "#{outcome} #{description}".send(pass? ? :green : :red)
    end

    def to_s
      [newline, title, units.join(''), newline].join('')
    end
  end

  class Expression < Group
    def to_s
      "#{newline}#{context} #{units.length > 1 ? "#{indent}..." : ''}" + units.join('')
    end
  end

  class Question
    def to_s
      phrase.send(outcome.pass? ? :green : :red)
    end
  end

  class Outcome
    def report
      "pass: #{pass_count}, fail: #{fail_count}, errors: #{error_count}"
    end

    def to_s
      pass? ? '✔' : 'x'
    end
  end

  class Arguments
    def pretty_print(pp)
      pp.text '('
      pp.seplist(args)
      pp.text ',' if !args.empty? && block
      pp.text if block
      pp.text ')'
    end

    def to_s
      "(#{args.join(', ')}#{block ? ' &{|| ... }' : ''})"
    end
  end

  class SomeValue
    def pretty_print(pp)
      pp.text '('
      pp.pp value
      pp.text ", '#{description}'" if description
      pp.text ')'
    end

    def to_s
      description || value.to_s
    end
  end

  class Message
    def to_s
      value.to_s + (description ? " (#{description})" : '')
    end
  end

  class Context
    def pretty_print(pp)
      pp.pp to_h
    end

    def to_s
      [message,
       arguments,
       message && subject ? 'on' : nil,
       subject].reject(&:nil?).join(' ')
    end
  end
end
