require 'speq/version'
require 'speq/test'
require 'speq/matcher'
require 'speq/report'
require 'speq/unit'
require 'speq/fake'
require 'speq/action'
require 'speq/cli'

module Speq
  @tests = [Test.new]

  def self.test(&block)
    self << Test.new
    module_exec(&block)
  end

  def self.<<(test)
    @tests << test
  end

  module_function

  def method_missing(method_name, *args, &block)
    if Action.instance_methods.include?(method_name)
      Action.new(@tests.last).send(method_name, *args, &block)
    else
      super
    end
  end

  def report
    Report.new(@tests).print_report
  end

  def fake(**mapping)
    Fake.new(mapping)
  end
end
