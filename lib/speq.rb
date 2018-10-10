require 'speq/version'
require 'speq/test'
require 'speq/match'
require 'speq/fake'
require 'speq/cli'

module Speq
  module_function

  def does(subject, &block)
    Test.new(subject, self, &block).report
  end
end
