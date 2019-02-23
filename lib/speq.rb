require 'speq/version'
require 'speq/test'
require 'speq/fake'

# Build specs with fewer words
module Speq
  def self.test(&block)
    Test.new(&block)
  end

  module_function

  def speq(*args)
    Test.new { speq(*args) }
  end

  def is(*args, &block)
    Test.new { is(*args, &block) }
  end

  def on(*args, &block)
    Test.new { on(*args, &block) }
  end

  def does(*args, &block)
    Test.new { does(*args, &block) }
  end

  def fake(**mappings)
    Fake.new(**mappings)
  end
end
