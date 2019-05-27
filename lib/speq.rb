require 'speq/version'
require 'speq/test'
require 'speq/fake'

# Build specs with fewer words
module Speq
  def self.test(&block)
    Test.new(&block)
  end

  module_function

  def fake(**mappings)
    Fake.new(**mappings)
  end
end
