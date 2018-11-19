require 'speq/version'
require 'speq/test'
require 'speq/matcher'
require 'speq/report'
require 'speq/unit'
require 'speq/fake'
require 'speq/action'
require 'speq/cli'

module Speq
  module_function

  def method_missing(method, *args, &block)
    if Action.instance_methods.include?(method)
      Action.new.send(method, *args, &block)
    else
      super
    end
  end

  def fake(**mapping)
    Fake.new(mapping)
  end
end
