require 'speq/version'
require 'speq/test'
require 'speq/matcher'
require 'speq/report'
require 'speq/unit'
require 'speq/fake'
require 'speq/cli'

module Speq
  module_function

  def method_missing(method, *args)
    if Matcher.respond_to?(method)
      Matcher.send(method, *args)
    else
      super
    end
  end

  def unit_test(message, **kwargs)
    matcher_method = kwargs.keys.find { |key| Matcher.respond_to?(key) }
    matcher = send(matcher_method, kwargs[matcher_method])

    unit = Unit.new(message, kwargs[:on], kwargs[:with], matcher)
    Report.new([unit]).print_report

    unit.passed?
  end
end
